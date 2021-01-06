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

resource "aws_vpc" "cyberark-homework" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "cyberark-homework" {
  cidr_block = "${cidrsubnet(aws_vpc.cyberark-homework.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.cyberark-homework.id}"
  availability_zone = "eu-central-1a"
}

resource "aws_internet_gateway" "cyberark-homework" {
  vpc_id = "${aws_vpc.cyberark-homework.id}"

}

resource "aws_route_table" "route-table-cyberark-homework" {
  vpc_id = "${aws_vpc.cyberark-homework.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.cyberark-homework.id}"
  }

}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.cyberark-homework
.id}"
  route_table_id = "${aws_route_table.route-table-cyberark-homework.id}"
}

resource "aws_security_group" "ssh" {
name = "allow-ssh-from-anywhere"
vpc_id = "${aws_vpc.cyberark-homework.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_instance" "web-app-1" {
  ami = "ami-0a09486b18ca1a617"
  instance_type = "t2.micro"
  key_name = "dreckguy"
  subnet_id = aws_subnet.cyberark-homework.id
  vpc_security_group_ids = [aws_security_group.ssh.id]
    associate_public_ip_address = true

    provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"

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
output "web-app-1_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.web-app-1.public_ip
}