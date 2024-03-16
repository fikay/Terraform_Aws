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


# resource "aws_network_interface" "makinates-NI" {
#   subnet_id   = aws_subnet.public.id
#   private_ip_list_enabled = true
#   private_ip_list = [ "10.0.0.6", "10.0.0.7" ]
#   security_groups = [ aws_security_group.allow_tls.id ]
#   # attachment {
#   #   instance = aws_instance.web.id
#   #   device_index = 1
#   # }
#   tags = {
#     Name = "primary_network_interface"
#   }
# }

# resource "aws_eip" "Ec2" {
#   # domain                    = "vpc"
#   # network_interface         = aws_network_interface.makinates-NI.id
#   # vpc = true
#   instance = aws_instance.web.id
#   network_interface = aws_network_interface.makinates-NI.id
#   depends_on = [ aws_internet_gateway.Igw ]
#   # associate_with_private_ip = "10.0.0.6"
#   tags = {
#     Name = "Elastic-Ip"
#   }
# }



# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
# network_interface {
#   network_interface_id = aws_network_interface.makinates-NI.id
#   device_index = 0
# }
# # associate_public_ip_address = true
# user_data = <<-EOF
#                 #!/bin/bash
#                 sudo apt update -y
#                 sudo apt install apache2 -y 
#                 sudo systemctl start apache2
#                 sudo bash -c 'echo your very firdt web server > /var/www/html/index.html'
#             EOF
#   tags = {
#     Name = "EC2-Makinates"
#   }
#}