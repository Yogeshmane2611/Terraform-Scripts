provider "aws" {
  region = "ap-south-1"
}


#Create VPC
resource "aws_vpc" "web-vpc" {
  cidr_block = var.web-vpc
  tags = {
    Name = "Web-VPC"
  }
}


#Create Private Subnet
resource "aws_subnet" "Private" {
  count             = length(var.subnet_cidr)
  vpc_id            = aws_vpc.web-vpc.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}


#Create Public Subnet
resource "aws_subnet" "Public" {
  vpc_id                  = aws_vpc.web-vpc.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}


#Create Internet Gateway and attach to VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.web-vpc.id
  tags = {
    Name = "IGW_Web-App"
  }
}

#Create Elastic IP for NAT Gateway
resource "aws_eip" "eip-nat" {
  domain = "vpc"
  tags = {
    Name = "NAT IP"
  }
}

#Create NAT Gateway
resource "aws_nat_gateway" "NAT" {
  subnet_id = aws_subnet.Public.id
  allocation_id = aws_eip.eip-nat.id
}


#Create Private Route Table and associate subnets
resource "aws_route_table" "Private_RT" {
  vpc_id = aws_vpc.web-vpc.id
  tags = {
    Name = "Private_RT"
  }
}
resource "aws_route_table_association" "PrivateRT-attach" {
  count          = 2
  subnet_id      = aws_subnet.Private[count.index].id
  route_table_id = aws_route_table.Private_RT.id
}
resource "aws_route_table_association" "PublicRT-attach" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_vpc.web-vpc.main_route_table_id
}


#Add route to public route table
resource "aws_route" "route" {
  route_table_id         = aws_vpc.web-vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW.id
}

resource "aws_route" "nat-route" {
  route_table_id = aws_route_table.Private_RT.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.NAT.id
}

