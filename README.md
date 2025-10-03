# terraform-eks-automation for VPC ECR and EKS

**Problem Statement: Highlighting a Real World Problem:**

A fast-growing startup is deploying a microservices-based web application on AWS. Initially, developers were manually building Docker images on their laptops, pushing them to a shared 

DockerHub account, and deploying workloads directly onto an EC2 instance.

**This caused three big issues:**

A. Manual Effort & Errors – Every developer had to repeat the Docker build and push process, leading to inconsistencies.

B. Scalability Problems – As the team grew, managing container images and deployments manually became unmanageable.

C. Security & Reliability Risks – Public DockerHub images and ad-hoc EC2 deployments posed risks and lacked proper access control.

The company needed a secure, automated, and scalable deployment workflow for its containerized applications.

**Solution:**

**A single Terraform stack that:**

(A). Builds a Terraform module-based VPC with public and private subnets, a NAT gateway, route tables (public and private), and security groups (bastion, application server).

(B). It also builds container images from Dockerfiles, provisions ECR Repositories, tags the container images, and updates them automatically in Kubernetes manifests.

(C). It can also push container images to ECR repositories.

(D). It can deploy an AWS EKS Cluster and then pull container images from ECR and deploy them as pods within the cluster.

Resource Names include an environment suffix so the same code can be used for dev/stage/prod by swapping *.tfvars.

**Step-by-Step Instructions to deploy the project via Terraform:**

Install Terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Install AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Configure AWS CLI: https://youtu.be/TF9oisb1QJQ

4A. Create an S3 Bucket: aws s3api create-bucket --bucket tf-state- --region us-east-1  # Optional, only required if you want Terraform state file to be stored on an S3 bucket

4B. Create a SSH key-pair: aws ec2 create-key-pair --key-name train2 --key-type rsa --key-format pem

# Optional, only required if you want terraform state file locking enabled
Create DynamoDB table for state locking:
aws dynamodb create-table --table-name tf-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
--region us-east-1

**Explanation of the different command flags:**

--table-name tf-locks → Name of the DynamoDB table

--attribute-definitions → Defines LockID as a string (S)

--key-schema → Sets LockID as the partition key (HASH)

--provisioned-throughput → 1 read & 1 write per second (enough for Terraform)

--region → Region where the table will be created

git clone https://github.com/bhavukm/terraform-eks-automation.git

cd terraform-eks-automation

Replace all placeholders in the Terraform script files:

terraform init

terraform plan -var-file=dev.tfvars

terraform apply -var-file=dev.tfvars -auto-approve

Verify from the AWS Management Console that all AWS resources have been created successfully, like ECR, EKS, and VPC

# On the CLI:

kubectl get nodes

kubectl get pods -n three-tier

To destroy all resources: Run >> terraform destroy -var-file=dev.tfvars -auto-approve
