#!/bin/bash
terraform apply -auto-approve

terraform output | tr -d " "\" > compose/.env
export WEB_APP_1_IP=$(terraform output web-app-1_ip| tr -d " "\")
export DB_IP=$(terraform output db_ip| tr -d " "\")
export LB_DNS=$(terraform output lb_dns| tr -d " "\")
echo "starting db"
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$DB_IP "docker run -p 8529:8529 -e ARANGO_NO_AUTH=1 -d arangodb"
scp -i key.pem -o "StrictHostKeyChecking no" compose/.env ubuntu@$WEB_APP_1_IP:/home/ubuntu/
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$WEB_APP_1_IP "docker-compose -f /home/ubuntu/docker-compose.yml pull"
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$WEB_APP_1_IP "docker-compose -f /home/ubuntu/docker-compose.yml run app init.js"
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$WEB_APP_1_IP "docker-compose -f /home/ubuntu/docker-compose.yml docker-compose up"
echo "reading directors:"
curl "$LB_DNS/directors"
