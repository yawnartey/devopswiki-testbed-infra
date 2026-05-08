output "vpc_id" {
  value = aws_vpc.devopswiki-testbed-vpc.id
}
output "subnet_ids" {
  value = {
    "testbed-fe-subnet" = aws_subnet.testbed-fe-subnet.id
    "testbed-be-subnet" = aws_subnet.testbed-be-subnet.id
  }
}
