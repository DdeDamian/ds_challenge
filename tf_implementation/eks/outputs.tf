# -------------------------------------------------------------
# EKS outputs
# -------------------------------------------------------------

output "eks_cluster_endpoint" {
  value       = module.main_eks_cluster.cluster_endpoint
  description = "Shows the endpoint for your Kubernetes API server"
}

output "eks_cluster_name" {
  value       = module.main_eks_cluster.cluster_name
  description = "The name of the EKS main cluster"
}
