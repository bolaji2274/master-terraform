terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# create a vpc 
resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
    cidr_block = var.vpc_cidr_block

  tags = {
    "Name" = "Production ${var.main_vpc_name}"
  }
}

resource "aws_subnet" "web" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnet
  availability_zone = var.subnet_zone
  tags = {
    "Name" = "Web Subnet"
  }
}

resource "aws_internet_gateway" "my_web_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "${var.main_vpc_name} Internet Gateway"
  }
}

resource "aws_default_route_table" "main_vpc_default_route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_web_igw.id
  }

  tags = {
    "Name" = "${var.main_vpc_name} Default Route Table"
  }
}

resource "aws_default_security_group" "default_sec_group" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = [var.my_public_ip]
    
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Default Security Group"
  }
}

resource "aws_instance" "my_vm" {
  ami = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.web.id
  vpc_security_group_ids = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name = "my_ssh_key"

  tags = {
    "Name" = "My EC2 instance - Amazon Linux 2"
  }
}