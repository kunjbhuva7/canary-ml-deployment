module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "ml-eks"
  cluster_version = "1.27"
  enable_irsa     = true
  vpc_id          = "vpc-0fe1403e8c0a90591"
  subnet_ids      = ["subnet-09b2621a5509c137b", "subnet-0f7876e5059bb0c06"]

  create_kms_key = false

  eks_managed_node_groups = {
    default = {
      name           = "default-node-group"
      instance_types = ["t2.micro"]
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      ami_type       = "AL2_x86_64"
    }
  }
}  # <-- this closes the module block

