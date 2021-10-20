variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "private_subnet_ids" {
  type = list(any)
}

variable "eks_version" {
  default = "1.20"
}

variable "project_name" {}
variable "project_environment" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {}

variable "node_groups" {
  default = [
    {
      node_group_name = "default",
      capacity_value  = "SPOT",
      instance_types  = ["t3.medium"],
      labels          = { ClusterDesignation = "WorkerNode" },
      tags            = { ClusterDesignation = "WorkerNode" },
      desired_size    = 1,
      max_size        = 10,
      min_size        = 1
    }
  ]
}

variable "statefulset_groups" {
  default = [
    {
      node_group_name = "default",
      capacity_value  = "ON_DEMAND",
      instance_types  = ["t3.medium"],
      labels          = { ClusterDesignation = "WorkerNode" },
      tags            = { ClusterDesignation = "WorkerNode" },
      desired_size    = 1,
      max_size        = 10,
      min_size        = 1,
      subnet_index    = 1
    }
  ]
}

