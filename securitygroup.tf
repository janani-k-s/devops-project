resource "aws_security_group" "dp_security_group" {
  name        = "dp-security-group"
  description = "Security group for DP EC2 instances"
  vpc_id      = aws_vpc.dp_vpc.id

  tags = {
    Name = "dp-security-group"
  }
}


resource "aws_vpc_security_group_ingress_rule" "dp_ssh_ingress_rule" {
  security_group_id = aws_security_group.dp_security_group.id

  cidr_ipv4   = var.ssh_allowed_cidr
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "dp_http_ingress_rule" {
  security_group_id = aws_security_group.dp_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "dp_egress_rule" {
  security_group_id = aws_security_group.dp_security_group.id

  cidr_ipv4 = "0.0.0.0/0"

  ip_protocol = "-1"

}
