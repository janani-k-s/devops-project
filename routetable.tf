resource "aws_route_table" "dp_route_table" {
  vpc_id = aws_vpc.dp_vpc.id


  tags = {
    Name = "dp-route-table"
  }
}

resource "aws_route" "dp_route" {
  route_table_id         = aws_route_table.dp_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dp_igw.id
}

resource "aws_route_table_association" "dp_route_table_association_1" {
  subnet_id      = aws_subnet.dp_public_subnet_1.id
  route_table_id = aws_route_table.dp_route_table.id
}

resource "aws_route_table_association" "dp_route_table_association_2" {
  subnet_id      = aws_subnet.dp_public_subnet_2.id
  route_table_id = aws_route_table.dp_route_table.id
}