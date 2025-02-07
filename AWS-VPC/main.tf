

provider "aws" {
  region     = "ap-south-1"
  
}

# VPC

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

#public subnet

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}

#private subnet

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-subnet"
  }
}

# SG

resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysg"
  }
}

# IGW

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myigw"
  }
}

# eip for natgateway

resource "aws_eip" "myeipfornatgateway" {
  domain   = "vpc"
}

# NAT Gateway

resource "aws_nat_gateway" "mynatgateway" {
  allocation_id = aws_eip.myeipfornatgateway.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = "mynatgateway"
  }
}

# public RT

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# private RT

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mynatgateway.id
  }

  tags = {
    Name = "private-rt"
  }
}

# public-rt Association

resource "aws_route_table_association" "imtipu-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

# private-rt Association

resource "aws_route_table_association" "imtipr-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rt.id
}

# keypair

resource "aws_key_pair" "keypair" {
  key_name   = "project"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgYP5iZ/IwdKQN5OXXz985E9twes+sb6jyQ+SNcX2+Iqvsfr5fJcgTMQ28syRhcgHDFHLUTbBM8DWUoa2t31066TGgB3iuhNGL0QqLDLA+WbN2AleQiYP9oOm1ZoCSICBqn4afZoJZydtQa33WhtFYtgcmmdFfm1xA52LIFYoYrty76xIxxTjeL4ItO6CkB3I5Udq9fUk+ST/7UDz+b0mBh5gNUTjY1+U0VdYWpCbu7di2KFcG05CKlc2KvFJuKMtVwzevFG/ghziihBEeJXpR1yhJfAc6UlQqa4QRMAPIeCS0u84LW7DgolhAcRQRv3vvoKLN0CNN80ePHbVkmKCAXm3veAu0BJlAVt9JeWi2OOKq8xdAXf6LaeTblRjbM1UlyClm0DhBnWGeK/jig43urrHEPHvSfxEXA62GYvo+3PQtlHp2EY5f/ZMs0dbBoxMjHPYTeKrzyUUh84n/B40cAhucCrNJnGs9Onk6cLK89/f5bhut7UXUZJhyALdo5uc= root@ip-172-31-6-138.ap-south-1.compute.internal"
}
# eip for webserver

resource "aws_eip" "lb" {
  instance = aws_instance.web-server.id
  domain   = "vpc"
}

# webserver

resource "aws_instance" "web-server" {
  ami           = "ami-0a0f1259dd1c90938"
  instance_type = "t3.micro"
  subnet_id= aws_subnet.public-subnet.id
  vpc_security_group_ids= [aws_security_group.mysg.id]
  key_name="project"

  tags = {
    Name = "web-server"
  }
}

# dbserver

resource "aws_instance" "db-server" {
  ami           = "ami-0a0f1259dd1c90938"
  instance_type = "t3.micro"
  subnet_id= aws_subnet.private-subnet.id
  vpc_security_group_ids=[aws_security_group.mysg.id]
  key_name="project"

  tags = {
    Name = "db-server"
  }
}

# output of eip

output "eip" {
  value = aws_eip.lb.public_ip
}

# output of public instance id

output "instance_ids" {
  value = aws_instance.web-server.id
}