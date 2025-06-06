# update

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.36.0"
  cluster_name    = "ml-eks"
  cluster_version = "1.28" # Updated to a supported version (1.27 may be deprecated)
  subnet_ids      = ["subnet-0a27086d7c025dc1d", "subnet-0d4a85a1e3e90ee70"]
  vpc_id          = "vpc-0dea2e68bf671eea0"
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
      instance_types = ["t3.medium"] # Updated to a more suitable instance type
    }
  }
  cluster_enabled_log_types = ["api", "audit", "authenticator"]
}
