#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
sudo apt-add-repository ppa:ansible/ansible | echo -ne '\n';
sudo apt-get update;
sudo apt install ansible -y;
ansible --version;

#(sleep 1; echo) | useradd -m -s /bin/bash ansible;
#echo "------------------------------------------------------------IMPORTANT------------------------------------------------------------------------";
#echo "Your Ansible version has displayed above confirming successful installation also an ansible account has been created.";
#echo "Please use sudo passwd ansible to create the user account password and complete setup with ssh-keygen command.";
#echo "---------------------------------------------------------------------------------------------------------------------------------------------";
#curl -fsSL -o- https://bootstrap.pypa.io/pip/3.5/get-pip.py | python3.5;
#wget https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt;
#echo "---------------------------------------------------Checking pip3 installation version-------------------------------------------------------";
#pip3 --version;
#sudo pip3 install -r requirements-azure.txt;
#pip3 install ansible[azure];
sudo chmod +x ansible-ssh-automation.sh;

