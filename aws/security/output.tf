output "testbed_cp_security_group_id" {
  value = aws_security_group.testbed-cp-sg.id
}
output "testbed_fe_security_group_id" {
  value = aws_security_group.testbed-fe-worker-node-sg.id
}
output "testbed_be_security_group_id" {
  value = aws_security_group.testbed-be-worker-node-sg.id
}
