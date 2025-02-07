provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "server" {
  ami = "ami-0a0f1259dd1c90938"
  instance_type = var.instance_type
  

  root_block_device {
    delete_on_termination = true
    volume_size = var.ec2_config.v_size
    volume_type = var.ec2_config.v_type
  }

  tags = merge(var.add_tags, {
  Name="web-server"
   
  
  })
  }
  
   