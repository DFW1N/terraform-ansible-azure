#!/bin/bash

sudo apt-get upgrade -y;
sudo apt-add-repository ppa:ansible/ansible;
echo "---------------------------------------------------Please press enter-------------------------------------------------------";
sudo apt-get update;
sudo apt-get install ansible -y;
sudo apt-get install python -y;
echo "---------------------------------------------------Checking Python is installed-------------------------------------------------------";
sudo chmod +x azure-ssh.sh;
echo "---------------------------------------------------Installation Complete starting ssh key process-------------------------------------------------------";
mkdir ~/.azure && cd ~/.azure;
curl https://raw.githubusercontent.com/DFW1N/ansible-tower/main/credentials -o credentials;
cd ~/;
echo "------------------------------------------------IMPORTANT------------------------------------------------------------------------";
echo "Please view directory ~/.azure/credentials to input Azure Service Principal values for authentication";
echo "------------------------------------------------IMPORTANT------------------------------------------------------------------------";
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!starting keygen process!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
ssh-keygen;
cat ~/.ssh/id_rsa.pub;
echo "------------------------------------------------Please company this key into your node server-----------------------------------------------------";
echo "------------------------------------------------IMPORTANT------------------------------------------------------------------------------------------";
