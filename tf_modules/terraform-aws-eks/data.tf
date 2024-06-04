# -------------------------------------------------------------
# Certificate for OIDC thumbprint
# -------------------------------------------------------------
data "tls_certificate" "cluster_tls_cert" {
  url = aws_eks_cluster.masters.identity.0.oidc.0.issuer
}
