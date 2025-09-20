variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  default     = "t3.medium"
}

variable "node_desired_capacity" {
  description = "Number of worker nodes"
  default     = 2
}

variable "backend_image_tag" {
  default = "latest"
}

variable "frontend_image_tag" {
  default = "latest"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
}