provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcpp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "server" {
  ami = "ami-0b7207e48d1b6c06f"
  instance_type = "t2.micro"
  depends_on = [ aws_security_group.mysg ]
}