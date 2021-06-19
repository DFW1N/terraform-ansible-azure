#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg -y;
apt-add-repository ppa:ansible/ansible | echo -ne '\n';
apt-get update;
apt-get install ansible -y;
ansible --version;
(sleep 1; echo) | useradd -m -s /bin/bash ansible;
echo Your Ansible version has displayed above confirming successful installation also an ansible account has been created.;
echo Please use "sudo passwd ansible" to change the user account password and complete setup with "ssh-keygen".;
