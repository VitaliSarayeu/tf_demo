resource "aws_security_group" "sg_cluster" {
  name        = "${var.cluster_name}-cluster-sg" // make configurable with variables
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.standard_tags
}

resource "aws_security_group_rule" "cluster-ingress-workstation-https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_cluster.id
  to_port           = 443
  type              = "ingress"
}

// Worker nodes sg
resource "aws_security_group" "node" {
  name        = "${var.cluster_name}-cluster-worker-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      "Name"                                      = var.cluster_name
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    local.standard_tags
  )
}

resource "aws_security_group_rule" "node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.sg_cluster.id
  source_security_group_id = aws_security_group.sg_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.sg_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster-dns" {
  description              = "Allow DNS"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
  to_port                  = 65535
  type                     = "ingress"
}