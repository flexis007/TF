provider "aws" {
  region = "var.region"
}

module "ec2" {
  source = "./module/ec2"

  tags = {
    Name        = "Project"
    Environment = "dev"
  }
}

