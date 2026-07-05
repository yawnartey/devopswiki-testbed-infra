output "testbed_fe_public_ip" {
  value = aws_instance.devopswiki-testbed-fe.public_ip
}
output "testbed_be_pip" {
  value = aws_instance.devopswiki-testbed-be.private_ip
}
