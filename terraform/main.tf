module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "19.15.3"

  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  vpc_id          = "vpc-0fe1403e8c0a90591"
  subnet_ids      = ["subnet-09b2621a5509c137b", "subnet-0f7876e5059bb0c06"]

  enable_irsa     = true

  eks_managed_node_groups = {
    ubuntu_nodes = {
      instance_types = ["t3a.medium"]
      desired_size   = 1
      max_size       = 1
      min_size       = 1

      ami_id         = "ami-0f403e3180720dd7e" # ✅ Ubuntu 20.04 EKS-optimized for us-west-2
    }
  }

  cluster_enabled_log_types     = ["api", "audit", "authenticator"]
  create_cloudwatch_log_group   = true
  create_kms_key                = false

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

