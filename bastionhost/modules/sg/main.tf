
resource "aws_security_group" "security_group" {
  name        = var.sg_name
  description = "this is for terraform security"
  vpc_id      = var.vpc_id
  

  #inbound rule 
   dynamic "ingress" {
    for_each = var.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidr_blocks
      description = "Port -${ingress.value}- open"
    }
  }

  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #semantically equivalent to all ports
   cidr_blocks = var.egress_cidr_blocks
  }
#   tags = {
#     environment = var.env
#     Name = "${var.env}-terraform-sg"
#   }
}