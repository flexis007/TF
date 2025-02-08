provider "aws" {
  region = "ap-south-1"

  
}


resource "aws_s3_bucket" "example" {
  bucket = "flexis007-bucket"
}



