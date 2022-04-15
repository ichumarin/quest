#!/bin/bash
echo "Update repository and istall commands"
sleep 2
sudo yum update -y 
sudo yum install unzip wget git telnet -y

echo "Install terraform"
sleep 2
# below code installs terraform
sudo curl -O https://releases.hashicorp.com/terraform/0.14.11/terraform_0.14.11_linux_amd64.zip 
sudo unzip terraform_0.14.11_linux_amd64.zip 
sudo mv terraform /usr/bin/ 
sudo rm -rf terraform_0.14.11_linux_amd64.zip


echo "Install Docker"
sleep 2
# below code installs Docker
sudo amazon-linux-extras install docker -y 
sudo yum install docker -y 
sudo service docker start 
sudo systemctl enable docker 
sudo usermod -a -G docker ec2-user 

