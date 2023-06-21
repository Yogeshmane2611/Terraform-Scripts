variable "regions" {
  default = "ap-south-1"
}

variable "web-vpc" {
  default = "192.168.0.0/16"
}

variable "availability_zone" {
  default = [ "ap-south-1b", "ap-south-1c"]
}

variable "subnet_cidr" {
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "ami" {
  type = map
  default = {
    AWS_Linux = "ami-0607784b46cbe5816"
    Ubuntu = "ami-0f5ee92e2d63afc18"
    Windows = "ami-0b7acb262cc9ea2ea"
}
}