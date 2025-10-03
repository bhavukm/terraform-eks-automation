provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
#This configures the Kubernetes provider in Terraform to connect to your EKS cluster 
#using its API endpoint, CA certificate, and authentication token.