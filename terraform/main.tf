module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  subnet_ids      = ["subnet-09b2621a5509c137b", "subnet-0f7876e5059bb0c06"]
  vpc_id          = "vpc-0fe1403e8c0a90591"
  enable_irsa     = true

  create_kms_key = true

  cluster_encryption_config = [{
    resources = ["secrets"]
  }]
}

