provider "aws" {
  region = "ap-south-1"
}
/*
#AMI
data "aws_ami" "name" {
  most_recent = true
  owners = [ "amazon" ]
}

output "name" {
  value = data.aws_ami.name.id
}
*/

#SG

data "aws_security_group" "name" {
  tags = {
    server="http"
  }
}
output "namesg" {
  value = data.aws_security_group.name.id
}

#VPC
data "aws_vpc" "name" {
  tags = {
    ENV= "Prod"
  }
}

output "VPC" {
  value = data.aws_vpc.name.id
}

#Subnet ID
data "aws_subnet" "public" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.name.id]
  }
  tags = {
    Name="private-subnet"
  }
}

resource "aws_instance" "server" {
  ami = "ami-05fa46471b02db0ce"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ data.aws_security_group.name.id]
  subnet_id = data.aws_subnet.public.id
  tags = {
    name= "sample"
  }
}