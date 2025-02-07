resource "aws_instance" "web-server" {
  ami           = "ami-0a0f1259dd1c90938"
  instance_type = "t3.micro"
  subnet_id= aws_subnet.public-subnet.id
  vpc_security_group_ids= [aws_security_group.mysg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install nginx -y
              sudo systemctl start nginx

  EOF

  tags = {
    Name = "web-server"
  }
}