provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "My-VPC" {
  id = "vpc-06d06c5c045e11e3e"
}

resource "aws_key_pair" "test-key" {
  key_name   = "test-key"
  public_key = file("key1.pub")
}

resource "aws_instance" "linux" {
  ami                    = "ami-0b08bfc6ff7069aff"
  key_name               = aws_key_pair.test-key.key_name
  vpc_security_group_ids = ["sg-0dc93ca79666689ae"]
  instance_type          = "t2.micro"
  subnet_id              = "subnet-003045ca844992987"
  user_data              = file("userdata.sh")
}

output "private_ip" {
  value = aws_instance.linux.private_ip
}

output "public_ip" {
  value = aws_instance.linux.public_ip
}