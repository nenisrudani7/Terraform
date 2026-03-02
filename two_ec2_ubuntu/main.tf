# ── SSH Key Pair ─────────────────────────────────────────────────────────────

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload public key to AWS
resource "aws_key_pair" "ubuntu_key" {
  key_name   = "ubuntu-ec2-key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  # Save private key locally for SSH access
  provisioner "local-exec" {
    command = "echo \"$PRIVATE_KEY\" > terraform-key.pem && chmod 400 terraform-key.pem"
    environment = {
      PRIVATE_KEY = tls_private_key.ssh_key.private_key_pem
    }
  }
}



# ── VPC ───────────────────────────────────────────────────────────────────────

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { Name = "ubuntu-ec2-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = { Name = "ubuntu-ec2-subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "ubuntu-ec2-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "ubuntu-ec2-rt" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ── Security Group ────────────────────────────────────────────────────────────

resource "aws_security_group" "allow_ssh" {
  name        = "ubuntu-ec2-sg"
  description = "Allow SSH inbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ubuntu-ec2-sg" }
}

# ── Two EC2 Instances ─────────────────────────────────────────────────────────

resource "aws_instance" "ubuntu" {
  for_each = {
    ec2_1 = "Ubuntu EC2 Instance 1"
    ec2_2 = "Ubuntu EC2 Instance 2"
  }

  ami                         = var.ubuntu_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ubuntu_key.key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  availability_zone           = "${var.region}a"

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = { Name = each.key }

  depends_on = [aws_key_pair.ubuntu_key, aws_security_group.allow_ssh]
}
