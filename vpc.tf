resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops vpc"
  }
}

data "aws_availability_zones" "available" {}

# Define Public Subnets
resource "aws_subnet" "devops_public_subnets" {
  vpc_id = aws_vpc.devops_vpc.id
  count = length(data.aws_availability_zones.available.names)
  cidr_block = cidrsubnet(aws_vpc.devops_vpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "devops public subnets"
  }
}

# Define Private Subnets
resource "aws_subnet" "devops_private_subnets" {
  vpc_id = aws_vpc.devops_vpc.id
  count = length(data.aws_availability_zones.available.names)
  cidr_block = cidrsubnet(aws_vpc.devops_vpc.cidr_block, 8, (count.index + length(data.aws_availability_zones.available.names)))
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "devops private subnets"
  }
}

# Define Internet Gateway
resource "aws_internet_gateway" "devops_internet_gateway" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops internet gateway"
  }
}

# Define Egress-Only Internet Gateway
resource "aws_egress_only_internet_gateway" "devops_egress_only_internet_gateway" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops egress only internet gateway"
  }
}

# Define Route Tables
resource "aws_route_table" "devops_public_route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_internet_gateway.id
  }
  tags = {
    Name = "devops public route table"
  }
}

resource "aws_route_table" "devops_private_route_table" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.devops_egress_only_internet_gateway.id
  }
  tags = {
    Name = "devops private route table"
  }
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "devops_public_subnet_association" {
  count          = length(aws_subnet.devops_public_subnets)
  subnet_id      = aws_subnet.devops_public_subnets[count.index].id
  route_table_id = aws_route_table.devops_public_route_table.id
}

resource "aws_route_table_association" "devops_private_subnet_association" {
  count          = length(aws_subnet.devops_private_subnets)
  subnet_id      = aws_subnet.devops_private_subnets[count.index].id
  route_table_id = aws_route_table.devops_private_route_table.id
}