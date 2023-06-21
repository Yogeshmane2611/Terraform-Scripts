#Create Web Security Group 
resource "aws_security_group" "Web-SG" {
  vpc_id = aws_vpc.web-vpc.id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "Web-sg"
    }
}


#Create Web instance
resource "aws_instance" "Web1" {
  ami = var.ami.Ubuntu
  instance_type = "t2.micro"
  key_name = "Key"
  subnet_id = aws_subnet.Public.id
  security_groups = [aws_security_group.Web-SG.id]
  user_data = file("web_bash.sh")
  tags = {
    Name = "Web-app"
  }
}


#Output
output "Web-Public-IP" {
  value = aws_instance.Web1.public_ip
}