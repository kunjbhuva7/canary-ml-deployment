module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  enable_irsa     = true
  vpc_id          = "vpc-0fe1403e8c0a90591"
  subnet_ids      = ["subnet-09b2621a5509c137b", "subnet-0f7876e5059bb0c06"]

  create_kms_key = false

}  # <-- this closes the module block

