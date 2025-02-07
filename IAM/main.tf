provider "aws" {
  region = "ap-south-1"
}

locals {
  user_data= yamldecode(file("./users.yaml")).users
}

output "name" {
  value = local.user_data[*].username
}

#Create IAM user

resource "aws_iam_user" "main" {
  for_each = toset(local.user_data[*].username)
  name = each.value
}

resource "aws_iam_user_login_profile" "name" {
  for_each = aws_iam_user.main
  password_length = 12
  user = each.value.name

  lifecycle {
  ignore_changes = [ 
    pgp_key,
    password_length,
    password_reset_required
   ]
}
}

