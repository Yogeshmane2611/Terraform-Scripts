variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "vpc_cidr_block" {
  default = "192.168.0.0/16"
}

variable "subnet_cidr_block" {
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

