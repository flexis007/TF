
provider "aws" {
  region = var.region

  
}


resource "aws_s3_bucket" "example" {
  bucket = "flexis007-bucket"
}



resource "aws_s3_object" "demo-bucket" {
  
  bucket = aws_s3_bucket.example.bucket
  source = "./s3 data/myfile.txt"
  key = "mydata.txt"
}
