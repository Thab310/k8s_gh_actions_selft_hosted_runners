output "pub_sub_az1_id" {
  value = aws_subnet.public_az1.id
}

output "pub_sub_az2_id" {
  value = aws_subnet.public_az2.id
}

output "priv_sub_az1_id" {
  value = aws_subnet.private_az1.id
}

output "priv_sub_az2_id" {
  value = aws_subnet.private_az2.id
}