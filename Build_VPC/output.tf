output "public_instance_ipadress" {
  value = aws_instance.Web-instance.private_ip
}
output "private_instance_ipadress" {
  value = aws_instance.backend-instance.private_ip
}