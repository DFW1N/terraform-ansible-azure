#!/bin/bash

sudo apt-get upgrade -y;
sudo apt-add-repository ppa:ansible/ansible;
echo "---------------------------------------------------Please press enter-------------------------------------------------------";
sudo apt-get update;
sudo apt-get install ansible -y;
sudo apt-get install python -y;
echo "---------------------------------------------------Checking Python is installed-------------------------------------------------------";
echo "---------------------------------------------------Installation Complete starting ssh key process-------------------------------------------------------";
mkdir ~/.azure && cd ~/.azure;
sudo curl https://raw.githubusercontent.com/DFW1N/ansible-tower/main/credentials -o credentials;
cd ~/;
echo "------------------------------------------------IMPORTANT------------------------------------------------------------------------";
echo "Please view directory ~/.azure/credentials to input Azure Service Principal values for authentication";
echo "------------------------------------------------IMPORTANT------------------------------------------------------------------------";
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!starting keygen process!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!";
ssh-keygen;
echo "------------------------------------------------Please company this key into your node server-----------------------------------------------------";
echo "--------------------------------------------------------------------------------------------------------------------------------------------------";
cat ~/.ssh/id_rsa.pub;
echo "------------------------------------------------Please company this key into your node server-----------------------------------------------------";
echo "------------------------------------------------Send this ssh key to your node by using this command-----------------------------------------------------";
echo "------------------------------------------------ssh-copy-id 192.187.34.12 {NODE_IP_ADDRESS}-----------------------------------------------------";
