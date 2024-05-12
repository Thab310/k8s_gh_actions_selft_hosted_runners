output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "cluster_ca_cert" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}