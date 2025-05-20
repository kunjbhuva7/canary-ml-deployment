terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.36.0"
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  subnet_ids      = ["subnet-09b2621a5509bb0c06", "subnet-09b2621a5509c137b"]
  vpc_id          = "vpc-0fe1403e8c0a90591"
  enable_irsa     = true
  create_kms_key  = true
  cluster_encryption_config = {
    resources = ["secrets"]
  }
  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t2.micro"]
    }
  }
  cluster_enabled_log_types = ["api", "audit", "authenticator"]
}
