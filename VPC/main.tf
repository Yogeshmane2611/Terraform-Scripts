provider "aws" {
  region = "ap-south-1"
}
#VPC Creation
resource "aws_vpc" "VPC1" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC1"
  }
}

#Subnet Creation
resource "aws_subnet" "Subnet" {
  count                   = length(var.subnet_cidr_block)
  vpc_id                  = aws_vpc.VPC1.id
  cidr_block              = var.subnet_cidr_block[count.index]
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true
}

#IGW Creation
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC1.id
  tags = {
    Name = "VPC1_IGW"
  }
}

#Route Table Creation
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.VPC1.id
  tags = {
    Name = "VPC1_RT"
  }
}

#Route table association
resource "aws_route_table_association" "RT_associate" {
  count          = length(aws_subnet.Subnet)
  subnet_id      = aws_subnet.Subnet[count.index].id
  route_table_id = aws_route_table.RT.id
}

#Add internet route to route table
resource "aws_route" "route" {
  count                  = length(var.subnet_cidr_block)
  route_table_id         = aws_route_table.RT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGW.id
}

#Security Group
resource "aws_security_group" "sg" {
  description = "This is default security group"
  vpc_id = aws_vpc.VPC1.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }
  egress {
    to_port = 0
    from_port = 0
    protocol = -1
    cidr_block = ["0.0.0.0/0"]
  }
  tags = {
    Name = "VPC1_SG"
  }
}

#Create EC2 Instance
resource "aws_instance" "Linux" {
  ami                    = "ami-0b08bfc6ff7069aff"
  key_name               = "Key"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = element(aws_subnet.Subnet[*].id, 0)
  instance_type          = "t2.medium"
  tags = {
    Name = "Linux"
  }
}


#Create Network Interface
resource "aws_network_interface" "LAN" {
  subnet_id  = element(aws_subnet.Subnet[*].id, 0)
  private_ip = "10.0.0.100"
  tags = {
    Name = "LAN"
  }
}

resource "aws_network_interface" "WAN" {
  subnet_id  = element(aws_subnet.Subnet[*].id, 0)
  private_ip = "10.0.0.200"
  tags = {
    Name = "WAN"
  }
}


#Create Elastic IP
resource "aws_eip" "ip1" {
  vpc = true
  tags = {
    Name = "Elastic_IP"
  }
}


#Attach ENI to EC2
resource "aws_network_interface_attachment" "attach2ec2-1" {
  instance_id          = aws_instance.Linux.id
  network_interface_id = aws_network_interface.LAN.id
  device_index         = 1
}

resource "aws_network_interface_attachment" "attach2ec2-2" {
  instance_id          = aws_instance.Linux.id
  network_interface_id = aws_network_interface.WAN.id
  device_index         = 2
}


#Attach Elastic IP to ENI
resource "aws_eip_association" "elastic_ip" {
  network_interface_id = aws_network_interface.WAN.id
  allocation_id        = aws_eip.ip1.id
}


#Output
output "Public_IP" {
  value = aws_instance.Linux.public_ip
}