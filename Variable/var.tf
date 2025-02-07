variable "instance_type" {
  type = string

  validation{
    condition = var.instance_type=="t2.micro" || var.instance_type=="t3.micro"
    error_message = "only t2 and t3 micro allowed"
  }
}


variable "ec2_config" {
  type = object({
    v_size = number
    v_type= string
  })
  default = {
    v_size = 20
    v_type = "gp2"
  }
}

variable "add_tags" {
type = map(string)
default = {}
}
