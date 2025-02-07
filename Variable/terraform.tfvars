instance_type = "t2.micro"

ec2_config = {
  v_size = 30
  v_type = "gp3"
}

add_tags = {
  DEP = "QA"
  PROJECT="PERSONAL"
}