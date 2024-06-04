# --------------------------------------------------------------------
# AWS EKS resources
# --------------------------------------------------------------------

## EKS cluster (K8S control plane)
resource "aws_eks_cluster" "masters" {
  name     = var.cluster_name
  version  = var.k8s_version
  role_arn = var.create_master_role ? aws_iam_role.k8s_masters_role[0].arn : var.master_role_arn

  vpc_config {
    # The subnet IDs where ENIs will be placed for communication between masters and nodes.
    # If placed in private subnets, K8S will not be able to find public subnets for deploying
    # 'LoadBalancer' services for workloads. These ENIs are assigned with private IPs only,
    # even when they are in public subnets.
    subnet_ids = var.public_subnets_ids

    # The security group to attach to the EKS ENIs. Only traffic between master and nodes is allowed.
    security_group_ids = [aws_security_group.k8s_masters_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}

### OIDC config
resource "aws_iam_openid_connect_provider" "cluster_oidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.tls_certificate.cluster_tls_cert.certificates.0.sha1_fingerprint], var.oidc_thumbprint_list)
  url             = aws_eks_cluster.masters.identity.0.oidc.0.issuer
  tags            = var.oidc_tags
}

## Launch configuration for K8S worker nodes ASG
resource "aws_launch_configuration" "workers_launch_config" {
  count                       = var.create_asg ? 1 : 0
  name_prefix                 = "${var.cluster_name}-workers-launch-config"
  image_id                    = local.ami_id
  instance_type               = var.workers_instance_type
  iam_instance_profile        = aws_iam_instance_profile.iam_workers_profile[0].name
  key_name                    = var.keypair_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.k8s_workers_sg.id]
  user_data_base64            = base64encode(local.worker_userdata["amazon"])

  root_block_device {
    volume_type           = var.boot_volume_type
    volume_size           = var.boot_volume_size
    iops                  = var.iops
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Autoscaling group for K8S worker nodes
resource "aws_autoscaling_group" "workers_asg" {
  count                = var.create_asg ? 1 : 0
  name_prefix          = "${var.cluster_name}-workers-asg"
  min_size             = var.asg_min_size
  desired_capacity     = var.asg_desired_size
  max_size             = var.asg_max_size
  launch_configuration = aws_launch_configuration.workers_launch_config[0].id
  target_group_arns    = [var.lb_target_group]
  vpc_zone_identifier  = var.private_subnets_ids

  dynamic "tag" {
    for_each = var.asg_tags
    content {
      key                 = tag.value.key
      propagate_at_launch = tag.value.propagate_at_launch
      value               = tag.value.value
    }
  }

  depends_on = [aws_eks_cluster.masters]
}

## EKS Workers: node group for K8S worker nodes
resource "aws_eks_node_group" "workers_ng" {
  count           = length(var.node_groups) > 0 ? length(var.node_groups) : 0
  cluster_name    = aws_eks_cluster.masters.name
  node_group_name = lookup(var.node_groups[count.index], "name")
  node_role_arn   = var.create_ng_role ? aws_iam_role.ng[0].arn : var.ng_role_arn
  subnet_ids      = var.private_subnets_ids
  release_version = lookup(var.node_groups[count.index], "release_version")
  version         = lookup(var.node_groups[count.index], "k8s_version")
  capacity_type   = lookup(var.node_groups[count.index], "capacity_type")

  remote_access {
    ec2_ssh_key               = var.keypair_name
    source_security_group_ids = [aws_security_group.k8s_workers_sg.id]
  }

  scaling_config {
    desired_size = lookup(var.node_groups[count.index], "scaling_config_desired_size")
    max_size     = lookup(var.node_groups[count.index], "scaling_config_max_size")
    min_size     = lookup(var.node_groups[count.index], "scaling_config_min_size")
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  disk_size      = lookup(var.node_groups[count.index], "disk_size")
  instance_types = lookup(var.node_groups[count.index], "instance_types")

  tags = {
    "Name" = "${lookup(var.node_groups[count.index], "name")}-${count.index}"
  }

  labels = {
    "ec2-pricing-model" = lookup(var.node_groups[count.index], "ec2_pricing_model")
  }

}
