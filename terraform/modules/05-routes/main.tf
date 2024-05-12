resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = {
    Name = "${var.project}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "${var.project}-public"
  }
}

resource "aws_route_table_association" "private_az1" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.priv_sub_az1_id
}

resource "aws_route_table_association" "private_az2" {
  route_table_id = aws_route_table.private.id
  subnet_id      = var.priv_sub_az2_id
}

resource "aws_route_table_association" "public_az1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.pub_sub_az1_id
}

resource "aws_route_table_association" "public_az2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = var.pub_sub_az2_id
}