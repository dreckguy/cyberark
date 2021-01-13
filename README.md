# cyberark
## Prerequisites
1. bash installed with curl
2. terraform installed
3. aws cli configured
4. aws key pair named 'key'
## Installation
1. clone repository
2. cd into it
3. run start.sh script
## See if it works
1. The script should print the requested directors data in json format.
2. The script will print the URL of the Load Balancer. In order to check the result just copy and paste it in the browser.
It should print the requested data in the browser.

## Clean resources
Run 'terraform destroy' and aprove with 'yes'
## Some notes
The application was built with 'docker-compose build; docker-compose push' from the root of the project with my personal dockerhub registry configured and with build section uncommented. The relevant images are stored there publicly for the instances use.
