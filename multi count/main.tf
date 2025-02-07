provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name= "${local.project}-vpc"
  }
}

locals {
  project="Dev-01"
}

#create 4 Ec2
resource "aws_instance" "main" {
  ami = "ami-0b7207e48d1b6c06f"
  instance_type = "t2.micro"
  count = 4
  subnet_id = element(aws_subnet.main[*].id , count.index % length(aws_subnet.main))

  tags = {
    Name= "${local.project}-instance${count.index}"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count = 2
  tags = {
    Name= "${local.project}-subnet${count.index}"
  }
}