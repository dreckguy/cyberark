#!/bin/bash
terraform apply -auto-approve
echo db_ip=$(terraform output db_ip) >> compose/.env
scp -i key.pem -o "StrictHostKeyChecking no" compose/.env ubuntu@$(terraform output web-app-1_ip):/home/ubuntu/
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$(terraform output web-app-1_ip) "docker-compose -f /home/ubuntu/docker-compose.yml pull"
