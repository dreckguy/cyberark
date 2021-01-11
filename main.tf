terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "terraform_example_elb"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP Web from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP Arangodb access from the VPC

  ingress {
    from_port   = 8529
    to_port     = 8529
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = [aws_subnet.default.id]
  security_groups = [aws_security_group.elb.id]
  instances       = [aws_instance.web-app-1.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_instance" "web-app-1" {
  ami = "ami-0a09486b18ca1a617"
  instance_type = "t2.micro"
  key_name = "key"
  subnet_id = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]
    associate_public_ip_address = true

    provisioner "file" {
    source      = "compose/"
    destination = "/home/ubuntu/"

    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("key.pem")
    }
  }

    provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("key.pem")
    }

    scripts = [
                "scripts/install_docker_ubuntu_20.04.sh"
              ]
  }

}

resource "aws_instance" "db" {
  ami = "ami-0a09486b18ca1a617"
  instance_type = "t2.micro"
  key_name = "key"
  subnet_id = aws_subnet.default.id
  vpc_security_group_ids = [aws_security_group.default.id]
    associate_public_ip_address = true

    provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = self.public_ip
      private_key = file("key.pem")
    }

    scripts = [
                "scripts/install_docker_ubuntu_20.04.sh"
              ]
  }

}

output "web-app-1_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.web-app-1.public_ip
}

output "db_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.db.public_ip
}