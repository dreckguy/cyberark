output "web-app-1_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.web-app-1.public_ip
}

output "web-app-2_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.web-app-2.public_ip
}
output "db_ip" {
  description = "The public ip for ssh access"
  value = aws_instance.db.public_ip
}

output "lb_dns" {
  description = "dns of the elastic load balancer"
  value = aws_elb.web.dns_name
}