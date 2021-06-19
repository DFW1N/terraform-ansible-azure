#!/bin/bash

mkdir ~/.azure && cd ~/.azure;
curl https://raw.githubusercontent.com/DFW1N/ansible-tower/main/credentials -o credentials;
ssh-keygen -t rsa;
echo -ne '\n';
chmod 755 ~/.ssh;
touch ~/.ssh/authorized_keys;
chmod 644 ~/.ssh/authorized_keys;
ssh-copy-id -i adminuser@127.0.0.1;
