# 1. VPC resources
# Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "my-vpc"
    "Env" = "Production"
  }
}

# Create Internet gate way
resource "aws_internet_gateway" "prod-gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# Create  public route table
resource "aws_route_table" "prod-public-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod-gw.id
  }

  tags = {
    "Env" = "Production"
    "Name" = "Public"
  }
}

# Create private route table
resource "aws_route_table" "prod-private-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  route {
    cidr_block ="0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    "Env" = "Production"
    "Name" = "Private"
  }
}

# Create subnets
resource "aws_subnet" "prod-public-subnet" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "Public"
    "Env" = "Production"
  }
}

resource "aws_subnet" "prod-private-subnet" {
  vpc_id = aws_vpc.prod-vpc.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Private"
    "Env" = "Production"
  }
}

# Associate subnet with Route table
resource "aws_route_table_association" "public-association" {
  subnet_id = aws_subnet.prod-public-subnet.id
  route_table_id = aws_route_table.prod-public-route-table.id
}

resource "aws_route_table_association" "private-association" {
  subnet_id = aws_subnet.prod-private-subnet.id
  route_table_id = aws_route_table.prod-private-route-table.id
}

# NAT Gateway
resource "aws_eip" "nat" {
  vpc = true

  tags = {
    "Name" = "NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.prod-public-subnet.id

  tags = {
    Name = "gw NAT"
  }
}
