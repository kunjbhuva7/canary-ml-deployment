module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.29.2"        # ya koi stable latest version
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  subnet_ids      = ["subnet-09b2621a5509bb0c06", "subnet-09b2621a5509c137b"]
  vpc_id          = "vpc-0fe1403e8c0a90591"
  enable_irsa     = true

  create_kms_key = true

  cluster_encryption_config = [{
    resources = ["secrets"]
  }]

  # Ab node_groups nahi, balki "node_groups" ke jagah "node_group" use karenge:
  node_group = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t2.micro"
    }
  }

  # cluster_logging ke liye:
  enabled_cluster_log_types = ["api", "audit", "authenticator"]
}

