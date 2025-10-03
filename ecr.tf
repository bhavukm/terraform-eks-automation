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

#This builds the backend Docker image locally, tags it with the ECR repository URL, 
#and pushes it to AWS ECR using a null_resource with a local-exec provisioner.
#A null_resource lets Terraform run arbitrary actions without managing real infrastructure.
#a local-exec provisioner runs shell commands on the machine where Terraform is executed.

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
#This generates a Kubernetes backend.yaml file from a template, replacing placeholders with the backend ECR image URL.

resource "local_file" "frontend_yaml" {
  content = templatefile("${path.module}/k8s-templates/frontend.yaml.tpl", {
    frontend_image_url = "${aws_ecr_repository.frontend.repository_url}:latest"
  })
  filename = "${path.module}/k8s/frontend.yaml"
}