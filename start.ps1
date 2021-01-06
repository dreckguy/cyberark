terraform apply -auto-approve
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$(terraform output instance_ip) "docker-compose -f /home/ubuntu/docker-compose.yml pull"