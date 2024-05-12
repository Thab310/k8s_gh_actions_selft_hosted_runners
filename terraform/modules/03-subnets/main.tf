
resource "aws_subnet" "private_az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_az1_cidr_block
  availability_zone       = var.az1 //var.az1
  map_public_ip_on_launch = false

  tags = {
    "Name"                                  = "private-${var.az1}"
    "kubernetes.io/role/internal-elb"       = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_az2_cidr_block
  availability_zone       = var.az2 //var.az2
  map_public_ip_on_launch = false

  tags = {
    "Name"                                  = "private-${var.az2}"
    "kubernetes.io/role/internal-elb"       = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_az1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_az1_cidr_block
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    "Name"                                  = "public-${var.az1}"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_az2_cidr_block
  availability_zone       = var.az2
  map_public_ip_on_launch = true

  tags = {
    "Name"                                  = "public-${var.az2}"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/${var.eks_name}" = "owned"
  }
}