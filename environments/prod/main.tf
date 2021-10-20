module "vpc" {
  source = "../../modules/aws/vpc"

  project_name        = var.project_name
  project_environment = var.project_environment

  additional_private_subnet_tags = { "kubernetes.io/cluster/${var.cluster_name}" = "shared" }
  additional_public_subnet_tags  = { "kubernetes.io/cluster/${var.cluster_name}" = "shared" }
}

module "cluster" {
  source     = "../../modules/aws/eks"
  depends_on = [module.vpc]

  project_name        = var.project_name
  project_environment = var.project_environment
  cluster_name        = var.cluster_name

  aws_region         = "eu-cenral-1"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = concat(module.vpc.private_subnet_ids, module.vpc.public_subnet_ids)
  private_subnet_ids = module.vpc.private_subnet_ids

  node_groups = [
    {
      node_group_name = "default_workers",
      capacity_value  = "SPOT",
      instance_types  = ["t3.medium"],
      labels          = { ClusterDesignation = "WorkerNode" },
      tags            = { ClusterDesignation = "WorkerNode" },
      desired_size    = 1,
      max_size        = 10,
      min_size        = 1
    }
  ]

  statefulset_groups = [
    {
      node_group_name = "redis",
      capacity_value  = "ON_DEMAND",
      instance_types  = ["t3.medium"],
      labels          = { ClusterDesignation = "RedisNode" },
      tags            = { ClusterDesignation = "RedisNode" },
      desired_size    = 2,
      max_size        = 2,
      min_size        = 2,
      subnet_index    = 1
    }
  ]
}