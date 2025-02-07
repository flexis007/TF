variable "region" {
    type = string
    default = "ap-south-1"
}

variable "instance" {
type = string
default = "t2.micro"
}

variable "tags" {
  type = map(string)
  default = {}
}