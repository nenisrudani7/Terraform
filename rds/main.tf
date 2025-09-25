resource "aws_security_group" "demo-rds-sg" {
  name        = "terraform-practise"
  description = "Created By Terraform"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "rds-sql" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  identifier              = "demo-rds-terraform"
  username                = "practise"
  password                = "jvasccqte7yibxwyst2i2db"
  vpc_security_group_ids  = [aws_security_group.demo-rds-sg.id]
  publicly_accessible = true

 
  db_name                 = "practise"
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
  
  tags = {
    name = "dev-rds"
    Environment = "dev"
  }
}
