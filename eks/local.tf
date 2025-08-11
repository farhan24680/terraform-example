locals {
    region          = "ap-south-1"
    name            = "my-eks-cluster"
    vpc_cidr        = "10.0.0.0/16"
    public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
    private_subnets = ["10.0.201.0/24", "10.0.202.0/24"]
    intra_subnet    = ["10.0.203.0/24", "10.0.204.0/24"]
    azs             = ["ap-south-1a", "ap-south-1b"]
    env             = "dev"

    tags = {
      Terraform   = "true"
      Environment = "dev"
    }   
}