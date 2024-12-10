variable "aws_secret_key" {
  
}

variable "aws_access_key" {

}

variable "vpc_cidr_block" {
    default = "10.0.0.0/16" 
}

variable "web_subnet" {
    default = "10.0.10.0/24"
}

variable "subnet_zone" {
  default = "us-east-1a"
}

variable "main_vpc_name" {

}