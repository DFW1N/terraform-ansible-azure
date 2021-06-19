#!/bin/bash

mkdir ~/.azure && cd ~/.azure;
curl https://raw.githubusercontent.com/DFW1N/ansible-tower/main/credentials -o credentials;
ssh-keygen -t rsa;
chmod 755 ~/.ssh;
touch ~/.ssh/authorized_keys;
chmod 644 ~/.ssh/authorized_keys;
ssh-copy-id -i adminuser@127.0.0.1;
cat ~/.ssh/id_rsa;
echo "------------------------------------------------------------IMPORTANT------------------------------------------------------------------------";
echo "Please view directory ~/.azure/credentials for file to input Azure Service Principal values";
echo "------------------------------------------------------------IMPORTANT------------------------------------------------------------------------";
