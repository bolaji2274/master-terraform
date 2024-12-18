output "ec2_public_ip" {
    description = "The public IP of the EC2 instance "
    value = aws_instance.my_vm.public_ip
}

output "vpc_id" {
    description = "Aws vpc main ID"
    value = aws_vpc.main.id
}

output "aws_ami" {
    description = "The ami instance image"
    value = aws_instance.my_vm.ami
}