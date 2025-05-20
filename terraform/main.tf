module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.15.3"

  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  vpc_id          = "vpc-0fe1403e8c0a90591"
  subnet_ids      = ["subnet-09b2621a5509c137b", "subnet-0f7876e5059bb0c06"]

  enable_irsa     = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    dev = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator"]
  cluster_log_group_name    = "/aws/eks/ml-eks/cluster"
  create_cloudwatch_log_group = false

  create_kms_key   = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

