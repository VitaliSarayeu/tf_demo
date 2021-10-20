resource "aws_eks_node_group" "workers" {
  count           = length(var.node_groups)
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.node_groups[count.index].node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  capacity_type   = var.node_groups[count.index].capacity_value
  instance_types  = var.node_groups[count.index].instance_types
  version         = var.eks_version
  tags = merge(
    local.standard_tags,
    var.node_groups[count.index].tags
  )
  labels = merge(
    {
      AWSBillingType = var.node_groups[count.index].capacity_value
    },
    var.node_groups[count.index].labels
  )

  scaling_config {
    desired_size = var.node_groups[count.index].desired_size
    max_size     = var.node_groups[count.index].max_size
    min_size     = var.node_groups[count.index].min_size

  }
  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes        = [scaling_config[0].desired_size]
    create_before_destroy = true
  }

}

resource "aws_eks_node_group" "statefulset_nodes" {
  count           = length(var.statefulset_groups)
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.statefulset_groups[count.index].node_group_name
  node_role_arn   = aws_iam_role.node.arn
  // subnet_ids      = var.private_subnet_ids[var.statefulset_groups[count.index].subnet_index]
  subnet_ids     = [element(var.private_subnet_ids, var.statefulset_groups[count.index].subnet_index)]
  capacity_type  = var.statefulset_groups[count.index].capacity_value
  instance_types = var.statefulset_groups[count.index].instance_types
  version        = var.eks_version
  tags = merge(
    local.standard_tags,
    var.statefulset_groups[count.index].tags
  )
  labels = merge(
    {
      AWSBillingType = var.statefulset_groups[count.index].capacity_value
    },
    var.statefulset_groups[count.index].labels
  )

  scaling_config {
    desired_size = var.statefulset_groups[count.index].desired_size
    max_size     = var.statefulset_groups[count.index].max_size
    min_size     = var.statefulset_groups[count.index].min_size

  }
  depends_on = [
    aws_eks_cluster.cluster,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes        = [scaling_config[0].desired_size]
    create_before_destroy = true
  }

}
