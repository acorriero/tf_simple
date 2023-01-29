resource "aws_vpc" "ac_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "ac-vpc"
  }
}

resource "aws_subnet" "ac_public_subnet" {
  vpc_id                  = aws_vpc.ac_vpc.id
  cidr_block              = "10.0.100.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    "Name" = "ac-public"
  }
}

resource "aws_internet_gateway" "ac_igw" {
  vpc_id = aws_vpc.ac_vpc.id

  tags = {
    "Name" = "ac-igw"
  }
}

resource "aws_route_table" "ac_public_rt" {
  vpc_id = aws_vpc.ac_vpc.id

  tags = {
    "Name" = "ac-public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.ac_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ac_igw.id
}

resource "aws_route_table_association" "ac_public_assoc" {
  subnet_id      = aws_subnet.ac_public_subnet.id
  route_table_id = aws_route_table.ac_public_rt.id
}