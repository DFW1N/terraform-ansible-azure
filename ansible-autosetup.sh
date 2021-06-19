#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg;
apt-add-repository ppa:ansible/ansible | echo -ne '\n';
apt-get update;
apt-get install ansible -y;
ansible --version;
printf Please wait 5 seconds for the command to start please do not cancel the bash script in the mean time thank you.;
(sleep 5; echo) | useradd -m -s /bin/bash ansible;
