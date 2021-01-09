$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
terraform apply -auto-approve
echo db_ip=$(terraform output db_ip) >> compose/.env
ssh -i key.pem -o "StrictHostKeyChecking no" ubuntu@$(terraform output web-app-1_ip) "docker-compose -f /home/ubuntu/docker-compose.yml pull"