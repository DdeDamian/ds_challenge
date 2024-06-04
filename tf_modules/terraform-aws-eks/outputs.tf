# -------------------------------------------------------------
# Settings exported by the module (outputs)
# -------------------------------------------------------------

# Shows the endpoint for your Kubernetes API server
output "cluster_endpoint" {
  value = aws_eks_cluster.masters.endpoint
}

# Shows nested attribute containing certificate-authority-data for your cluster
output "cluster_ca" {
  value = aws_eks_cluster.masters.certificate_authority
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.masters.name
}

# Shows the ID of the security group
output "workers_security_group_id" {
  value = aws_security_group.k8s_workers_sg.id
}

# Shows the encrypted eks ami Id
output "enrypted_ami_id" {
  value = join("", aws_ami_copy.encrypted_eks_ami.*.id)
}

output "oidc_arn" {
  description = "Openid connect provider ARN"
  value       = aws_iam_openid_connect_provider.cluster_oidc.arn
}
