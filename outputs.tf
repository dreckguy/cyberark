output "web-app-1_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.web-app-1.public_ip
}

output "db_pubic_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.db.public_ip
}

output "db_private_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.db.private_ip
}


output "lb_dns" {
  description = "dns of the elastic load balancer"
  value = aws_elb.web.dns_name
}