#!/bin/bash
terraform apply -auto-approve
terraform output | tr -d " "\" > compose/.env
export WEB_APP_1_IP=$(terraform output web-app-1_ip| tr -d " "\")
scp -i key.pem -o "StrictH ostKeyChecking no" compose/.env ubuntu@$WEB_APP_1_IP:/home/ubuntu/
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$WEB_APP_1_IP "docker-compose -f /home/ubuntu/docker-compose.yml pull; \
ocker-compose -f /home/ubuntu/docker-compose.yml run app init.js

