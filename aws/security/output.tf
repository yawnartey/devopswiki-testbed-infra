output "testbed_fe_security_group_id" {
  value = aws_security_group.testbed-fe-sg.id
}
output "testbed_be_security_group_id" {
  value = aws_security_group.testbed-be-sg.id
}
