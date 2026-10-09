resource "aws_instance" "dp_ec2_instance_1" {
  ami                    = "ami-0d27e0fb3bac4d724"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dp_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.dp_security_group.id]
  key_name               = "dp-key-pair"
  user_data              = file("user-data.sh")

  tags = {
    Name = "dp-ec2-instance-1"
  }
}

resource "aws_instance" "dp_ec2_instance_2" {
  ami                    = "ami-0d27e0fb3bac4d724"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.dp_public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.dp_security_group.id]
  key_name               = "dp-key-pair"
  user_data              = file("user-data.sh")


  tags = {
    Name = "dp-ec2-instance-2"
  }
}

