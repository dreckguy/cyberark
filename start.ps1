terraform apply -auto-approve
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$(terraform output web-app-1_ip) "docker-compose -f /home/ubuntu/docker-compose.yml pull"