
#Create SQL-server Security group
resource "aws_security_group" "sql-sg" {
  vpc_id = aws_vpc.web-vpc.id
  ingress {
    from_port = 1433
    to_port =  1433
    cidr_blocks = ["192.168.0.0/16"]
    protocol = "tcp"
  }
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = -1
  }
  tags = {
    Name = "SQL-sg"
  }
}


#Create SQL Server
resource "aws_instance" "SQL" {
  ami = var.ami.Ubuntu
  instance_type = "t2.micro"
  key_name = "Key"
  security_groups = [aws_security_group.sql-sg.id]
  subnet_id = aws_subnet.Private[0].id
  private_ip = "192.168.1.10"
  user_data = file("sql_bash.sh")
  tags = {
    Name = "SQL-Server"
  }
}

resource "aws_ssm_parameter" "ip-address" {
  name = "/sqldatabase/privateip"
  type = "String"
  value = aws_instance.SQL.private_ip
}


output "SQL-Private-IP" {
  value = aws_instance.SQL.private_ip
}