#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg;
apt-add-repository ppa:ansible/ansible | echo -ne '\n';
apt-get update;
apt-get install ansible -y;
ansible --version;
(sleep 3; echo) | useradd -m -p ansible -s /bin/bash ansible;
su ansible | (sleep 1; echo) | echo ansible;
