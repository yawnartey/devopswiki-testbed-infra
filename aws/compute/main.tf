# frontend ec2 instance
resource "aws_instance" "devopswiki-testbed-fe" {
  ami                    = "ami-075518ffc9234909a"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids["testbed-fe-subnet"]
  vpc_security_group_ids = [var.testbed_fe_security_group_id]
  iam_instance_profile   = var.testbed_fe_instance_profile
  user_data = templatefile("${path.module}/scripts/bootstrap-testbed-fe.sh", {
    be_private_ip     = aws_instance.devopswiki-testbed-be.private_ip
    yaw_public_key    = var.yaw_public_key
    postgres_user     = var.postgres_user
    postgres_password = var.postgres_password
  })
  tags = {
    Name = "DevOpsWiKi Testbed Frontend"
  }
}

# backend ec2 instance
resource "aws_instance" "devopswiki-testbed-be" {
  ami                    = "ami-075518ffc9234909a"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids["testbed-be-subnet"]
  vpc_security_group_ids = [var.testbed_be_security_group_id]
  user_data = templatefile("${path.module}/scripts/bootstrap-testbed-be.sh", {
    yaw_public_key    = var.yaw_public_key
    postgres_user     = var.postgres_user
    postgres_password = var.postgres_password
  })
  tags = {
    Name = "DevOpsWiKi Testbed Backend"
  }
}

# frontend eip. has been removed to save cost
# resource "aws_eip" "devopswiki-testbed-fe-eip" {
#   domain   = "vpc"
#   instance = aws_instance.devopswiki-testbed-fe.id
#   tags     = { Name = "DevOpsWiKi Testbed FE EIP" }
# }
