//EKS IAM ROLE
resource "aws_iam_role" "eks" {
  name = "${var.eks_name}-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

//EKS CLUSTER POLICY
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

//EKS CLUSTER
resource "aws_eks_cluster" "eks" {
  name     = var.eks_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]

    subnet_ids = [
      var.pub_sub_az1_id,
      var.pub_sub_az2_id,
      var.priv_sub_az1_id,
      var.priv_sub_az2_id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}