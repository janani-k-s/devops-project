resource "aws_internet_gateway" "dp_igw" {
  vpc_id = aws_vpc.dp_vpc.id

  tags = {
    Name = "dp-igw"
  }
}
