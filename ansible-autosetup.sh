#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg -y;
apt-add-repository ppa:ansible/ansible | echo -ne '\n';
apt-get update;
apt-get install ansible -y;
ansible --version;
(sleep 1; echo) | useradd -m -s /bin/bash ansible;
echo -e "\e[95m Your Ansible version has displayed above confirming successful installation also an ansible account has been created.";
echo -e "Please use \e[101m sudo passwd ansible \e[49m to create the user account password and complete setup with \e[101m ssh-keygen \e[49m command.";
