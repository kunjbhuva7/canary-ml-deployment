module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  subnet_ids      = ["subnet-09b2621a5509bb0c06", "subnet-09b2621a5509c137b"]
  vpc_id          = "vpc-0fe1403e8c0a90591"
  enable_irsa     = true

  create_kms_key = true

  cluster_encryption_config = [{
    resources = ["secrets"]
  }]

  # Node groups definition - worker nodes
  node_groups = {
    default_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t2.micro"

      # AMI type for Ubuntu - set if you want Ubuntu worker nodes
      ami_type = "AL2_x86_64" # This is Amazon Linux 2 by default; for Ubuntu use a custom AMI or different setup

      # If you want Ubuntu specifically, you will have to use custom AMI IDs or other ways (see module docs)
    }
  }

  # Enable cluster logging (optional)
  cluster_logging = {
    cluster_enabled_logs = ["api", "audit", "authenticator"]
  }
}

