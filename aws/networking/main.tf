# vpc
resource "aws_vpc" "devopswiki-testbed-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "DevOpsWiKi Testbed VPC"
  }
}

# internet gateway
resource "aws_internet_gateway" "devopswiki-testbed-igw" {
  vpc_id = aws_vpc.devopswiki-testbed-vpc.id
  tags = {
    Name = "DevOpsWiKi Testbed IGW"
  }
}

# frontend public subnet 
resource "aws_subnet" "testbed-fe-subnet" {
  vpc_id                  = aws_vpc.devopswiki-testbed-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = true
  tags = {
    Name = "DevOpsWiKi Testbed FE Subnet"
  }
}

# backend private subnet
resource "aws_subnet" "testbed-be-subnet" {
  vpc_id                  = aws_vpc.devopswiki-testbed-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-3a"
  map_public_ip_on_launch = false
  tags = {
    Name = "DevOpsWiKi Testbed BE Subnet"
  }
}

# elastic ip for nat gateway 
resource "aws_eip" "devopswiki-testbed-nat-eip" {
  domain = "vpc"
  tags = {
    Name = "DevOpsWiKi Testbed NAT EIP"
  }
}

# nat gateway - in testbed-fe-subnet for testbed-be-subnet outbound internet
resource "aws_nat_gateway" "devopswiki-testbed-nat" {
  allocation_id = aws_eip.devopswiki-testbed-nat-eip.id
  subnet_id     = aws_subnet.testbed-fe-subnet.id
  tags = {
    Name = "DevOpsWiKi Testbed NAT"
  }
}

# public route table for testbed-fe-subnet
resource "aws_route_table" "testbed-fe-route-table" {
  vpc_id = aws_vpc.devopswiki-testbed-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devopswiki-testbed-igw.id
  }
  tags = {
    Name = "DevOpsWiKi Testbed FE RT"
  }
}

# private route table for testbed-be-subnet
resource "aws_route_table" "testbed-be-route-table" {
  vpc_id = aws_vpc.devopswiki-testbed-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devopswiki-testbed-nat.id
  }
  tags = {
    Name = "DevOpsWiKi Testbed BE RT"
  }
}

# testbed-fe-subnet association to public route table
resource "aws_route_table_association" "testbed-fe-rt-association" {
  subnet_id      = aws_subnet.testbed-fe-subnet.id
  route_table_id = aws_route_table.testbed-fe-route-table.id
}

# testbed-be-subnet association to private route table
resource "aws_route_table_association" "testbed-be-rt-association" {
  subnet_id      = aws_subnet.testbed-be-subnet.id
  route_table_id = aws_route_table.testbed-be-route-table.id
}
