# =====================================
# ECR Repositories
# =====================================
resource "aws_ecr_repository" "backend" {
  name = "backend"
}

resource "aws_ecr_repository" "frontend" {
  name = "frontend"
}

# =====================================
# Backend Image Build & Push
# =====================================
resource "null_resource" "backend_image" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.backend.repository_url}
      docker build -t backend ./backend
      docker tag backend:latest ${aws_ecr_repository.backend.repository_url}:latest
      docker push ${aws_ecr_repository.backend.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.backend]
}

# =====================================
# Frontend Image Build & Push
# =====================================
resource "null_resource" "frontend_image" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.frontend.repository_url}
      docker build -t frontend ./frontend
      docker tag frontend:latest ${aws_ecr_repository.frontend.repository_url}:latest
      docker push ${aws_ecr_repository.frontend.repository_url}:latest
    EOT
  }

  depends_on = [aws_ecr_repository.frontend]
}

# =====================================
# Render Kubernetes Manifests from Templates
# =====================================
resource "local_file" "backend_yaml" {
  content = templatefile("${path.module}/k8s-templates/backend.yaml.tpl", {
    backend_image_url = "${aws_ecr_repository.backend.repository_url}:latest"
  })
  filename = "${path.module}/k8s/backend.yaml"
}

resource "local_file" "frontend_yaml" {
  content = templatefile("${path.module}/k8s-templates/frontend.yaml.tpl", {
    frontend_image_url = "${aws_ecr_repository.frontend.repository_url}:latest"
  })
  filename = "${path.module}/k8s/frontend.yaml"
}

# =====================================
# Apply Kubernetes Manifests
# =====================================
resource "null_resource" "deploy_k8s" {
  depends_on = [aws_eks_cluster.eks, aws_eks_node_group.ng]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name ${aws_eks_cluster.eks.name} --region ${var.aws_region}
      kubectl apply -f k8s/ --validate=false
    EOT
  }
}