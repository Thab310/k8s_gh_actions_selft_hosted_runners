resource "aws_eip" "nat" {
  domain = "vpc"


  tags = {
    Name = "${var.project}-nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.pub_az1_id

  tags = {
    Name = "${var.project}-nat"
  }

  //depends_on = [ aws_internet_gateway.igw ]
}