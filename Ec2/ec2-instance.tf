provider "aws" {
  region = var.region
}

data "aws_vpc" "My-VPC" {
  id = "vpc-06d06c5c045e11e3e"
}

resource "aws_instance" "test" {
  ami                    = var.amis
  instance_type          = "t2.micro"
  key_name               = "Key"
  vpc_security_group_ids = ["sg-0dc93ca79666689ae"]
  subnet_id              = "subnet-003045ca844992987"
  private_ip = "10.0.2.10"
  user_data = file("sql_bash.sh")
  tags = {
    Name = "Linux"
  }
}


output "private-ip" {
  value = aws_instance.test.private_ip
}

output "public-ip" {
  value = aws_instance.test.public_ip
}