module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                         = local.name
  kubernetes_version           = "1.33"
  endpoint_public_access       = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  addons = {
    vpc_cni   = { most_recent = true }
    kube_proxy = { most_recent = true }
    coredns   = { most_recent = true }
  }

  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {
    eks_cluster_ng = {
      instance_types                        = ["c7i-flex.large"]
      min_size                              = 1
      max_size                              = 3
      desired_size                          = 2
      capacity_type                         = "SPOT"
      # Add instance_requirements or other options here if needed
    }
  }

  tags = local.tags
}
