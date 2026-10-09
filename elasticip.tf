
resource "aws_eip" "dp_ec2_eip" {
  domain = "vpc"

  tags = {
    Name = "dp-ec2-elastic-ip"
  }
}

resource "aws_eip_association" "dp_ec2_eip_association" {
  instance_id   = aws_instance.dp_ec2_instance_1.id
  allocation_id = aws_eip.dp_ec2_eip.id
}

output "ec2_elastic_ip" {
  description = "Elastic IP of the deployment EC2 instance"
  value       = aws_eip.dp_ec2_eip.public_ip
}
