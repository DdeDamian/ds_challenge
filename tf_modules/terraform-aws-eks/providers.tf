data "aws_eks_cluster" "masters" {
  name = aws_eks_cluster.masters.id
}

data "aws_eks_cluster_auth" "masters_auth" {
  name = aws_eks_cluster.masters.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.masters.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.masters.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.masters_auth.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.masters.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.masters.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.masters_auth.token
  }
}
