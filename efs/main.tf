
resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Allow NFS traffic for EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict in production!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "efs-sg"
    Environment = "dev"
  }
}

# Create the EFS File System
resource "aws_efs_file_system" "efs" {
  creation_token = "efs-example"
  #   performance_mode = "generalPurpose"
  #   throughput_mode  = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  encrypted = true

  tags = {
    Name        = "efs-tf"
    Environment = "dev"
  }
}

# Create Mount Targets for each subnet
resource "aws_efs_mount_target" "efs_mount" {
  for_each        = toset(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}

# Output EFS Info
output "efs_id" {
  description = "EFS File System ID"
  value       = aws_efs_file_system.efs.id
}

output "efs_dns" {
  description = "EFS DNS Name"
  value       = aws_efs_file_system.efs.dns_name
}



variable "vpc_id" {
  type    = string
  default = "vpc-00fa2c67b20057328"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-0be8637d2ab8bdcc8", "subnet-024117b4a50af80cc"]
}

# to crearte efs we need a vpc subnet and efs 
#checking
