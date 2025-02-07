module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name = "single-instance"

  instance_type          = "t2.micro"
   ami = "ami-0b7207e48d1b6c06f"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Name   = "Project"
    Environment = "dev"
  }
}