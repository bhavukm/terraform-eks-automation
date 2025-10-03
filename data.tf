data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.eks.name
}
#These data sources fetch the EKS cluster’s details and authentication token so Terraform can access the cluster securely.

