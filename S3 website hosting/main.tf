provider "aws" {
  region = "ap-south-1"

}


resource "aws_s3_bucket" "example" {
  bucket = "flexis007-bucket"
}



resource "aws_s3_object" "demo-bucket" {
  
  bucket = aws_s3_bucket.example.bucket
  source = "./index.html"
  key = "index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.bucket
  policy = jsonencode(
    {
    Version="2012-10-17",
    Statement=[
        {
            Sid="PublicReadGetObject",
            Effect="Allow",
            Principal= "*",
            Action= "s3:GetObject",
            Resource=  "arn:aws:s3:::${aws_s3_bucket.example.bucket}/*"
            
        }
    ]
}
  )
}
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket

  index_document {
    suffix = "index.html"
  }
}

output "website" {
  value=aws_s3_bucket_website_configuration.example.website_endpoint
}
 



