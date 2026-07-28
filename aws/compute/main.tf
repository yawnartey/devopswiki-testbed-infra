# frontend ec2 instance
resource "aws_instance" "devopswiki-testbed-fe" {
  ami                    = "ami-075518ffc9234909a"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids["testbed-fe-subnet"]
  vpc_security_group_ids = [var.testbed_fe_security_group_id]
  iam_instance_profile   = var.testbed_instance_profile_name
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
  iam_instance_profile   = var.testbed_instance_profile_name
  user_data = templatefile("${path.module}/scripts/bootstrap-testbed-be.sh", {
    yaw_public_key    = var.yaw_public_key
    postgres_user     = var.postgres_user
    postgres_password = var.postgres_password
  })
  tags = {
    Name = "DevOpsWiKi Testbed Backend"
  }
}

# write public key to ssm
resource "aws_ssm_parameter" "yaw_public_key" {
  name  = "/devopswiki/yaw_public_key"
  type  = "SecureString"
  value = var.yaw_public_key
}

# store backend private ip in ssm
resource "aws_ssm_parameter" "be_private_ip" {
  name  = "/devopswiki/testbed/be_private_ip"
  type  = "String"
  value = aws_instance.devopswiki-testbed-be.private_ip
}

# store postgress user to ssm 
resource "aws_ssm_parameter" "postgres_user" {
  name  = "/devopswiki/testbed/postgres_user"
  type  = "SecureString"
  value = var.postgres_user
}

# store postgress password to ssm
resource "aws_ssm_parameter" "postgres_password" {
  name  = "/devopswiki/testbed/postgres_password"
  type  = "SecureString"
  value = var.postgres_password
}
