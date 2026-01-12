# create vpc
resource "aws_vpc" "precta" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    mode = "precta"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.precta.id

  tags = {
    mode = "precta"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}
//---------------------------------------------------------------------------------------------
# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.precta.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    mode = "precta"
  }
}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.precta.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

tags = {
  mode = "precta"
  "kubernetes.io/cluster/${var.project_name}_cluster" = "shared"
  "kubernetes.io/role/elb" = "1"
}

}

//---------------------------------------------------------------------------------------------
# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.precta.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    mode = "precta"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}



//---------------------------------------------------------------------------------------------
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.precta.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

tags = {
  mode = "precta"
  "kubernetes.io/cluster/${var.project_name}_cluster" = "shared"
  "kubernetes.io/role/internal-elb" = "1"
}

}


resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-eip"
  }
}

//---------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_az1.id
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags = {
    mode = "precta"
  }
}

# resource "aws_route" "private_nat_gateway" {
#   count                  = var.enable_nat_gateway ? 1 : 0
#   route_table_id         = aws_route_table.private_nat.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
# }


//---------------------------------------------------------------------------------------------
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.precta.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    mode = "precta"
  }
}



resource "aws_route_table_association" "private_nat_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}

