provider "aws" {
  region = var.region
}

resource "aws_key_pair" "test-key" {
  key_name   = "test-key"
  public_key = file("key1.pub")
}

resource "aws_instance" "my-linux" {
  ami                    = var.amis
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.test-key.key_name
  vpc_security_group_ids = ["sg-0dc93ca79666689ae"]
  subnet_id              = "subnet-003045ca844992987"
}