provider "aws" {
  region = "ap-south-1"
}
 data "aws_availability_zones" "name" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"



  name = "myvpc"
  cidr = "10.0.0.0/16"
  public_subnet_names = ["Public_subnet"]
  private_subnet_names = ["private_subnet"]
  public_subnets = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]
  azs = data.aws_availability_zones.name.names
map_public_ip_on_launch = true  # For ALL public subnets
  tags = {
    Name="test-vpc"
  }
}

