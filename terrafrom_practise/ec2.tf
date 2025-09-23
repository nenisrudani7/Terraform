
# to create this you need to have ssh key and vpc also  
# ssh-key
resource "aws_key_pair" "keys" {
  key_name   = "key_pair"
  public_key = file("/home/nenis/work/terraform_practise/terrafrom_practise/terraform-key.pub")
}

#VPC------------------------------------------------------------------

# for default vpc
# resource "aws_default_vpc" "terraform_vpc" {
#   tags = {
#     name = "default vpc"
#   }
# }

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/19"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true #to show output in output
  tags = {
    Name = "my-terraform-vpc"
  }
}


# subnet ---------------------------------
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "my_subnet"
  }
}

# internate gatway----------------------------------
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "internate gatway"
  }
}

# route table -----------------------------------------
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "practise_route_table"
  }
}

# route table associtation ------------------------------------------
resource "aws_route_table_association" "my_subnet_assoc" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# security_group ------------------------------------------------------

resource "aws_security_group" "security_group" {
  name        = "terraform-security-groups"
  description = "this is for terraform security"
  vpc_id      = aws_vpc.my_vpc.id #interpolatoin : is a way inwhich you can inherit  or extract value from terrafrom block  it's also called dot object notesion    
  

  #inbound rule 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH OPEN"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "8000 OPEN"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "80 OPEN"
  }
  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #semantically equivalent to all ports
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "terraform-sg"
  }
}

# instance-----------------------------------
resource "aws_instance" "demo" {
  # let's use forfor_each 
  # for_each = tomap({
  #   first_instance  = "t2.micro"
  #   second_instance = "t2.nano"
  # })
  # for multiple change together
  for_each = {
    first_instance = {
      instance_type = "t2.micro"
      ami           = "ami-0360c520857e3138f" #ubuntu
    }
    second_instance = {
      instance_type = "t2.nano"
      ami           = "ami-00ca32bbc84273381" #amazon
    }
     third_instance = {
      instance_type = "t2.small"
      ami           = "ami-00ca32bbc84273381" #amazon
    }
   
  }
  depends_on = [aws_security_group.security_group, aws_key_pair.keys]

  # count    = 2 #remove it cause here we use for_each
  key_name = aws_key_pair.keys.key_name #using interpolation
  #   security_groups             = [aws_security_group.security_group.name]
  # ami = "ami-0360c520857e3138f" #ubuntu
  ami = each.value.ami
  # instance_type          = var.ec2_types  #using variable
  instance_type          = each.value.instance_type
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.subnet.id
  #   user_data = file("command.sh")
  user_data                   = file("command.sh")
  associate_public_ip_address = true
  # This line forces AWS to assign a public IP to the instance.

  root_block_device {
    # volume_size = var.ec2_default_size
    volume_size = var.env == "production" ? 20 : var.ec2_default_size
    volume_type = "gp3"
  }
  tags = {
    # Name = "first ec2 created by terraform automation"
    Name = each.key
  }
}

# # import practise from aws exsiting resource here we will import exsiting instance from aws 
# resource "aws_instance" "import_new_ec2_from_aws" {
#   instance_type = "unkown"
#   ami           = "unknown"
# }
