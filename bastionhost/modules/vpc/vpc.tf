# create vpc
resource "aws_vpc" "prac" {
  cidr_block           = "10.128.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.prac.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}
//---------------------------------------------------------------------------------------------
# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.prac.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project_name}-public-subnet-az1"
    "kubernetes.io/role/elb" = 1
  }
}

# # create public subnet az2
# resource "aws_subnet" "public_subnet_az2" {
#   vpc_id                  = aws_vpc.bit.id
#   cidr_block              = var.public_subnet_az2_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[1]
#   map_public_ip_on_launch = true

#   tags = {
#     Name                     = "${var.project_name}-public-subnet-az2"
#     "kubernetes.io/role/elb" = 1
#   }
# }

# resource "aws_subnet" "public_subnet_az3" {
#   vpc_id                  = aws_vpc.bit.id
#   cidr_block              = var.public_subnet_az3_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[2]
#   map_public_ip_on_launch = true

#   tags = {
#     Name                     = "${var.project_name}-public-subnet-az3"
#     "kubernetes.io/role/elb" = 1
#   }
# }

//---------------------------------------------------------------------------------------------
# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.prac.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
# resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
#   subnet_id      = aws_subnet.public_subnet_az2.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "public_subnet_az3_route_table_association" {
#   subnet_id      = aws_subnet.public_subnet_az3.id
#   route_table_id = aws_route_table.public_route_table.id
# }
//---------------------------------------------------------------------------------------------
resource "aws_subnet" "private_subnet_az1" {
  vpc_id                  = aws_vpc.prac.id
  cidr_block              = var.private_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name                              = "${var.project_name}-private-subnet-az1"
    # "kubernetes.io/role/internal-elb" = 1
  }
}

# resource "aws_subnet" "private_subnet_az2" {
#   vpc_id                  = aws_vpc.bit.id
#   cidr_block              = var.private_subnet_az2_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[1]
#   map_public_ip_on_launch = false

#   tags = {
#     Name                              = "${var.project_name}-private-subnet-az2"
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }

# resource "aws_subnet" "private_subnet_az3" {
#   vpc_id                  = aws_vpc.bit.id
#   cidr_block              = var.private_subnet_az3_cidr
#   availability_zone       = data.aws_availability_zones.available_zones.names[2]
#   map_public_ip_on_launch = false

#   tags = {
#     Name                              = "${var.project_name}-private-subnet-az3"
#     "kubernetes.io/role/internal-elb" = 1
#   }
# }

resource "aws_eip" "nat" {
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
    Name = "${var.project_name}-nat-gateway"
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
  vpc_id = aws_vpc.prac.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${var.project_name}-nat-routetable"
  }
}



resource "aws_route_table_association" "private_nat_az1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_route_table.id
}


# resource "aws_route_table_association" "private_nat_az2" {
#   subnet_id      = aws_subnet.private_subnet_az2.id
#   route_table_id = aws_route_table.private_route_table.id
# }

# resource "aws_route_table_association" "private_nat_az3" {
#   subnet_id      = aws_subnet.private_subnet_az3.id
#   route_table_id = aws_route_table.private_route_table.id
# }




# Create CloudWatch Log Group
# resource "aws_cloudwatch_log_group" "vpc_flow_log_bit_prod" {
#   name              = "/aws/vpc/flow-logs-bit-prod"
#   retention_in_days = 14
# }

# # IAM Role for VPC Flow Logs
# resource "aws_iam_role" "vpc_flow_log_role_bit_prod" {
#   name = "vpcFlowLogRoleBITProd"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Effect = "Allow"
#       Principal = {
#         Service = "vpc-flow-logs.amazonaws.com"
#       }
#       Action = "sts:AssumeRole"
#     }]
#   })
# }

# IAM Policy attachment
# resource "aws_iam_role_policy_attachment" "vpc_flow_log_policy_attach_bit_prod" {
#   role       = aws_iam_role.vpc_flow_log_role_bit_prod.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
# }

# # Create VPC Flow Log
# resource "aws_flow_log" "vpc_flow_log_bit_prod" {
#   log_destination      = aws_cloudwatch_log_group.vpc_flow_log_bit_prod.arn
#   iam_role_arn         = aws_iam_role.vpc_flow_log_role_bit_prod.arn
#   traffic_type         = "ALL"
#   vpc_id               = aws_vpc.bit.id
#   log_destination_type = "cloud-watch-logs"
# }
