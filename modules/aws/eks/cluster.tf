resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.sg_cluster.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.policy-attachment-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.policy-attachment-AmazonEKSServicePolicy,
    aws_security_group.sg_cluster
  ]
  tags = merge(
    local.standard_tags,
    {
      Name = var.cluster_name
    }
  )
}