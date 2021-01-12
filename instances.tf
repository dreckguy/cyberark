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

resource "aws_instance" "web-app-2" {
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