resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "makinates"
  }
}
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Makinates-Igw"
  }
}

resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }
  tags = {
    Name = "Makinate-Public-route-table"
  }
}

resource "aws_route_table" "Private" {
  vpc_id = aws_vpc.main.id

  # route {
  #   cidr_block = "10.0.0.16/28"
  #   gateway_id = "local"
  # }
  tags = {
    Name = "Makinate-Private-route-table"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/28"

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.32/28"
  availability_zone = "us-west-2d"
  tags = {
    Name = "public-subnet2"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.16/28"

  tags = {
    Name = "private-subnet"
  }
}
resource "aws_route_table_association" "public-subnet-Association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.Public.id
}

resource "aws_route_table_association" "private-subnet-Association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.Private.id
}