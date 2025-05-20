# update

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.36.0"   # latest version
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  subnet_ids      = ["subnet-09b2621a5509bb0c06", "subnet-09b2621a5509c137b"]
  vpc_id          = "vpc-0fe1403e8c0a90591"
  enable_irsa     = true

  create_kms_key = true

  cluster_encryption_config = [{
    resources = ["secrets"]
  }]

  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t2.micro"
    }
  }

  cluster_logging = {
    enable = true
    types  = ["api", "audit", "authenticator"]
  }
}

