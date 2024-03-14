terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
     
  }

  required_version = ">= 1.2.0"

  # cloud {
  #   organization = "FaksOrg"
  #   hostname = "app.terraform.io" # Optional; defaults to app.terraform.io

  #   workspaces {
  #     name= "Fikayo-Infastructure"
      
  #   }
  # }
}

provider "aws" {
  region  = "us-west-2"
}


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

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "Makinate-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_Icmp" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = -1
  ip_protocol       = "icmp"
  to_port           = -1
}
resource "aws_network_interface" "makinates-NI" {
  subnet_id   = aws_subnet.public.id
  private_ip_list_enabled = true
  private_ip_list = [ "10.0.0.6", "10.0.0.7" ]
  security_groups = [ aws_security_group.allow_tls.id ]
  # attachment {
  #   instance = aws_instance.web.id
  #   device_index = 1
  # }
  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_eip" "Ec2" {
  # domain                    = "vpc"
  # network_interface         = aws_network_interface.makinates-NI.id
  # vpc = true
  //instance = aws_instance.web.id
  network_interface = aws_network_interface.makinates-NI.id
  depends_on = [ aws_internet_gateway.Igw ]
  # associate_with_private_ip = "10.0.0.6"
  tags = {
    Name = "Elastic-Ip"
  }
}



data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
network_interface {
  network_interface_id = aws_network_interface.makinates-NI.id
  device_index = 0
}
# associate_public_ip_address = true
user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y 
                sudo systemctl start apache2
                sudo bash -c 'echo your very firdt web server > /var/www/html/index.html'
            EOF
  tags = {
    Name = "EC2-Makinates"
  }
}