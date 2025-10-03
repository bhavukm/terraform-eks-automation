resource "null_resource" "k8s_apply" {
  depends_on = [
    aws_eks_node_group.ng,
    null_resource.backend_image,
    null_resource.frontend_image
  ]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${aws_eks_cluster.eks.name} --region ${var.aws_region}
      kubectl apply -f k8s/ --validate=false
    EOT
  }
}
#This runs a local command to apply all Kubernetes manifests in k8s/, 
#and unlike the earlier deploy_k8s resource, it specifically depends on the Docker images being built before applying the manifests.