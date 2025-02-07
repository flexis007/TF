provider "aws" {
  region = "ap-south-1"

  
}

terraform {
  backend "s3" {
    bucket = "flexis007-bucket"
    key    = "terraform.tfstat1"
    region = "ap-south-1"
  }
}


resource "aws_instance" "back" {
  ami = "ami-0b7207e48d1b6c06f"
    instance_type = "t2.micro"

    tags = {
      name="sample1"
    }
}
