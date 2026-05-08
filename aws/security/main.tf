# frontend security group
resource "aws_security_group" "testbed-fe-sg" {
  name        = "DevOpsWiKi Testbed FE SG"
  description = "Frontend Security groups definition"
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS access from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP access from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# backend security group
resource "aws_security_group" "testbed-be-sg" {
  name        = "DevOpsWiKi Testbed BE SG"
  description = "Backend security group definitions"
  vpc_id      = var.vpc_id

  # allow ssh from frontend only
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.testbed-fe-sg.id]
  }

  # allow app port from frontend only
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.testbed-fe-sg.id]
  }

  ingress {
    description     = "Backend access on port 8000"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.testbed-fe-sg.id]
  }

  # allow all outbound via NAT
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOpsWiKi Testbed BE SG"
  }
}
