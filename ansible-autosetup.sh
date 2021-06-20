#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg -y;
apt-add-repository ppa:ansible/ansible | echo -ne '\n';
apt-get update;
apt-get install ansible -y;
ansible --version;
(sleep 1; echo) | useradd -m -s /bin/bash ansible;
echo "------------------------------------------------------------IMPORTANT------------------------------------------------------------------------";
echo "\e[95m Your Ansible version has displayed above confirming successful installation also an ansible account has been created.";
echo "Please use sudo passwd ansible to create the user account password and complete setup with ssh-keygen command.";
echo "---------------------------------------------------------------------------------------------------------------------------------------------";
sudo apt install python3-pip -y;
sudo apt install python-pip -y;
wget https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt;
echo "---------------------------------------------------Checking pip3 installation version-------------------------------------------------------";
pip3 --version;
sudo pip3 install -r requirements-azure.txt;
pip3 install ansible[azure];
sudo chmod +x ansible-ssh-automation.sh;

