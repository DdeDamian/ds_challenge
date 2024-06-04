# --------------------------------------------------------------------
# Terraform data sources
# --------------------------------------------------------------------

## Get an Amazon Linux2 image optimized for EKS K8S workers using the given name
data "aws_ami" "amazon_eks_workers" {
  filter {
    name   = "name"
    values = [var.amzn_eks_worker_ami_name]
  }

  owners = ["602401143452", "self"] # Owned by Amazon and current account.
}

# -------------------------------------------------------------
# locals expressions to compute AMI ID and userdata script
# -------------------------------------------------------------

locals {
  ami_id = var.encrypted_boot_volume ? join("", aws_ami_copy.encrypted_eks_ami.*.id) : data.aws_ami.amazon_eks_workers.image_id

  priority_classes = { for priority_classes in var.priority_classes : priority_classes.name => priority_classes }

  worker_userdata = {
    ## cloud-init script to bootstrap Amazon Linux2 EKS-optimized image
    ## to configure kubeconfig for kubelet
    amazon = <<USERDATA
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name}
    USERDATA
  }

  k8s_all_namespaces    = concat(tolist(["default"]), var.k8s_namespaces)
  irsa_service_accounts = { for sa in var.irsa_service_accounts : sa.name => sa }

}

