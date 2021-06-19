#!/bin/bash

mkdir ~/.azure && cd ~/.azure;
curl https://raw.githubusercontent.com/DFW1N/ansible-tower/main/credentials -o credentials;
ssh-keygen -t rsa;
chmod 755 ~/.ssh;
touch ~/.ssh/authorized_keys;
chmod 644 ~/.ssh/authorized_keys;
ssh-copy-id adminuser@127.0.0.1;
sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg;
apt-add-repository ppa:ansible/ansible
apt-get update;
apt-get install ansible -y;
ansible --version
