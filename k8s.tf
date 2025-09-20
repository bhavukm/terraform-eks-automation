resource "null_resource" "k8s_apply" {
  provisioner "local-exec" {
    command = "kubectl apply -f k8s/"
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [
    aws_eks_node_group.ng,
    null_resource.backend_image,
    null_resource.frontend_image
  ]
}