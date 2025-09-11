
# to create this you need to have ssh key and vpc also  
# ssh-key
resource "aws_key_pair" "keys" {
  key_name   = "${var.env}-key_pair"
  public_key = file("/home/nenis/work/terraform_practise/terraform_module_app/infra_app/ec2.pub")

  tags = {
    environment = var.env

  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/19"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true #to show output in output
  tags = {
    environment = var.env
    Name = "${var.env}-my-terraform-vpc"
  }
}


# subnet ---------------------------------
resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    environment = var.env
    Name = "my_subnet"
  }
}

# internate gatway----------------------------------
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    environment = var.env
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
    environment = var.env
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
    environment = var.env
    name = "terraform-sg"
  }
}

# instance-----------------------------------
resource "aws_instance" "demo" {
  count = var.instance_number
  
  depends_on = [aws_security_group.security_group, aws_key_pair.keys]

 
  key_name = aws_key_pair.keys.key_name #using interpolation
 
  ami = var.ami_types
  # instance_type          = var.ec2_types  #using variable
  instance_type          = var.instance_types
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id              = aws_subnet.subnet.id

  associate_public_ip_address = true
  tags = {
    environment = var.env
  }
}
