provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Demo_vpc"
  }
}

# Internet gateway
resource "aws_internet_gateway" "demo_internet_gateway" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "Demo_internet_gateway"
  }
}

# create route table
resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_internet_gateway.id
  }

  tags = {
    Name = "Demo-route-table-public"
  }
}

# Create Public Subnet-1
resource "aws_subnet" "Demo-public-subnet1" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Demo-public-subnet1"
  }
}


# Create Public Subnet-2
resource "aws_subnet" "Demo-public-subnet2" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Demo-public-subnet2"
  }
}


# Associate public subnet 2 with public route table
resource "aws_route_table_association" "Demo-public-subnet1-association" {
  subnet_id      = aws_subnet.Demo-public-subnet1.id
  route_table_id = aws_route_table.demo_route_table.id
}

# Associate public subnet 2 with public route table
resource "aws_route_table_association" "Altschool-public-subnet2-association" {
  subnet_id      = aws_subnet.Demo-public-subnet2.id
  route_table_id = aws_route_table.demo_route_table.id
}


# creating instance 1
resource "aws_instance" "Server1" {
  ami               = "ami-00874d747dde814fa"
  instance_type     = "t2.micro"
  key_name          = "Demo"
  security_groups   = [aws_security_group.Demo-security-grp-rule.id]
  subnet_id         = aws_subnet.Demo-public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "Server-1"
    source = "terraform"
  }
}
# creating instance 2
resource "aws_instance" "Server2" {
  ami               = "ami-00874d747dde814fa"
  instance_type     = "t2.micro"
  key_name          = "Demo"
  security_groups   = [aws_security_group.Demo-security-grp-rule.id]
  subnet_id         = aws_subnet.Demo-public-subnet2.id
  availability_zone = "us-east-1b"
  tags = {
    Name   = "Server-2"
    source = "terraform"
  }
}
# creating instance 3
resource "aws_instance" "Server3" {
  ami               = "ami-00874d747dde814fa"
  instance_type     = "t2.micro"
  key_name          = "Demo"
  security_groups   = [aws_security_group.Demo-security-grp-rule.id]
  subnet_id         = aws_subnet.Demo-public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "Server-3"
    source = "terraform"
  }
}

resource "local_file" "Ip_address" {
  filename = "host-inventory"
  content  = <<EOT
${aws_instance.Server1.public_ip}
${aws_instance.Server2.public_ip}
${aws_instance.Server3.public_ip}
  EOT
}


