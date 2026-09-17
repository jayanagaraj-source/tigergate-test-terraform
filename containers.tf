# Insecure containers: ECR mutable + no scan, EKS public + wide-open access.
resource "aws_ecr_repository" "app" {
  name                 = "app"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_eks_cluster" "main" {
  name     = "insecure-eks"
  role_arn = "arn:aws:iam::123456789012:role/eks"
  vpc_config {
    subnet_ids             = ["subnet-0abc123", "subnet-0def456"]
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"]
  }
}
