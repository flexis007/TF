provider "aws" {
  region = var.region
}
resource "aws_instance" "webserver" {
    ami = "ami-0b7207e48d1b6c06f"
    instance_type = var.instance

    tags = {
      name="sample"
    }
  
}

