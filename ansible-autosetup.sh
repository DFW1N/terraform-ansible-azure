#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
apt-get install apt-transport-https wget gnupg -y;
apt-add-repository ppa:ansible/ansible | echo -ne '\n';
apt-get update;
apt-get install ansible -y;
ansible --version;
(sleep 1; echo) | useradd -m -s /bin/bash -p ansible ansible;
