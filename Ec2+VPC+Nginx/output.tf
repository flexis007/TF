output "public" {
  value = aws_instance.web-server.public_ip
}

output "instanceurl" {
  value = "http://${aws_instance.web-server.public_ip}"
}