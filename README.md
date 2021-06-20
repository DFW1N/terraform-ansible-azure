  <a target="_blank" href="HCL" title="HCL: Hashicorp Language"><img src="https://img.shields.io/badge/HashiCorp-HCL-red.svg"></a>
  <a target="_blank" href="https://www.python.org/downloads/" title="Python version"><img src="https://img.shields.io/badge/python-%3E=_3.5-yellow.svg"></a>
  ![OS](https://img.shields.io/badge/Written%20in-Shell-orange.svg?style=flat-square)

## [↑](#contents) Credits
Contributor:                                                [<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/DFW1N%20Logo.png" align="right" width="120">](https://github.com/DFW1N/DFW1N-OSINT)

- [Sacha Roussakis-Notter](https://github.com/DFW1N)

 [![Follow Sacha Roussakis | Sacha on Twitter](https://img.shields.io/twitter/follow/Sacha.svg?style=social&label=Follow%20%40Sacha)](https://twitter.com/intent/user?screen_name=sacha_roussakis "Follow Sacha Roussakis | Sacha on Twitter")

## 📖 Table of Contents
- [Introduction](#-introduction)
- [File Structure](#-file-structure)
- [main.tf](#-main-terraform)
- [Terraform Deployment](#-terraform-deployment-template-setup-for-ansible)
- [Create a Service Principal with a Client Secret](#-create-a-service-principal-with-a-client-secret)
- [Connecting to Terraform Cloud Remote Backend](#-connecting-to-terraform-cloud-remote-backend)
- [1.1 Connecting Terraform to there remote servers at app.terraform.io](#-connecting-terraform-to-there-remote-servers)
- [1.2 Configuring the Service Principal in Terraform](#-configuring-the-service-principal-in-terraform)
- [What is Terraform](#-what-is-terraform)
- [Create a Azure local blob storage account Container for tfstate backend file](#-create-a-azure-local-blob-storage-account-Container-for-tfstate-backend-file)
- [Deploy Terraform infrastructure commands](#-deploy-terraform-infrastructure-commands)
- [Create SSH Service Connection in Azure DevOps](#-create-ssh-service-connection-in-azure-devops)
- [Run the Shell Scripts](#-run-the-shell-scripts)
- [Ansible Installation on Ubuntu Linux [Without Bash Script]](#-snsible-installation-on-ubuntu-linux)
- [Ansible Tower Installation on Ubuntu Linux](#-ansible-tower-installation-on-ubuntu-linux)
- [Changing the following values from the inventory file](#-changing-the-following-values-from-the-inventory-file)
- [Review Ansible Playbooks for Azure](#-review-ansible-playbooks-for-azure)
- [Push Configurations to Remote Virtual Machines from Main Ansible Node Connector](#-push-configurations-to-remote-virtual-machines-from-main-ansible-node-connector)
- [Deployment Notes](#-notes)
- [Support](#-support)
- [Bugs & Errors](#-bugs-or-errors)

### [↑](#contents) Introduction

Terraform automation to create a virtual machine with Ubuntu 16.04 and using custom bash scripts to automate the setup for ansible to control and push configurations to remote hosts on Microsoft Azure.

1. Prerequisites : 
    * Azure CLI [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli]
    * PowerShell [https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell]
    * Terraform [https://learn.hashicorp.com/tutorials/terraform/install-cli]
    * Visual Studio Code [https://code.visualstudio.com/download
    * HashiCorp Terraform Extension [https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform]
    

### [↑](#contents) File Structure
* main.tf [infrastructure as code]
* provider.tf [service principle exports]
* variables.tf [infrastructure deployment variables]
* ansible-autosetup.sh [requires manual set up of ssh or using the ansible-ssh-automation shell script]
* ansible-ssh-automation.sh [Ensure you follow the prompts to correctly do it without doing it manually]
* README.md [File to help guide people through the installation process and explains the current repository]
* credentials [A file that has the values for your Azure Service Principle for Authentication]

### [↑](#contents) Main Terraform
* Linux Virtual Machine Ansible Main Node [Ubuntu 16.04]
* Virtual Network Interfaces
* Azure Network Security Group Association
* Azure Network Security Group
* Azure Public IP Adress
* Azure Subnet Internal
* Azure Resource Group
* Azure Virtual Network

### [↑](#contents) Terraform Deployment Template Setup for Ansible
* This template has been created for the purpose of deploying a Linux VM to Azure, using Terraform Infrastructure as Code to automatically provision an environment to deploy Ansible or Ansible Tower to a Enterprise environment rapidly and in an automated matter. This infrastructure has been written by Sacha Roussakis-Notter you can view more at: [Github](https://github.com/DFW1N/).

### [↑](#contents) 1.0 Create a Service Principal with a Client Secret
* Please Review for Hashicorp Guide for Azure Service Principal Authentication
    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

### [↑](#contents) Connecting to Terraform Cloud Remote Backend
* Register an account at : https://app.terraform.io/ [Recommend enabling MFA] > Create Organization > [+ New workspace]
* Ensure, Azure CLI, Powershell & Terraform are installed in Visual Studio Code open Terminal type : 

      terraform login

* Follow terminal prompts and creare a API token to authenticate with copy and paste code to your terminal once authenticated.
* Input backend remote code into your provider.tf file

                        terraform {
                    backend "remote" {
                        organization = "organization-value-name"

                        workspaces {
                        name = "workstation-value-name-you-set"
                        }
                    }
                    } 

### [↑](#contents) Configuring the Service Principal in Terraform
* Setting these values into your environment variable allows you to remove them from your code as these are SECRET and should not be shared.
* Once these variables are set restart your terminal and Visual Studio Code to allow it to take effect.

        setx ARM_CLIENT_ID "00000000-0000-0000-0000-000000000000"
        setx ARM_CLIENT_SECRET "00000000-0000-0000-0000-000000000000"
        setx ARM_SUBSCRIPTION_ID "00000000-0000-0000-0000-000000000000"
        setx ARM_TENANT_ID "00000000-0000-0000-0000-000000000000"

### [↑](#contents) What is Terraform
* What is Terraform? https://www.terraform.io/
* What is Azure? https://azure.microsoft.com/en-us/
* What is Ansible? https://www.ansible.com/
* What is Bash Script? https://ryanstutorials.net/bash-scripting-tutorial/bash-script.php

### [↑](#contents) Create a Azure local blob storage account Container for tfstate backend file

* Using Azure Storage Container to store state file instead of remote backend from terraform in code :

        terraform {
          backend "azurerm" {
            resource_group_name  = "Resource-Group-Name-Value"
            storage_account_name = "Account-Name-Value"
            container_name       = "tfstate"
            key                  = "00000000-0000-0000-0000-000000000000"
          }
        }

### [↑](#contents) Deploy Terraform infrastructure commands

* To deploy Terraform you must change some current values in the files but the main commands to Initialize, Plan, Build & Deploy it to Azure are the following :

      terraform init
      terraform fmt
      terraform plan
      terraform apply
      terraform destroy
 
* Once the infrastructure has been deployed locate the public ip address and connect to the vm through ssh :
        
         ssh -i ~/.ssh/id_rsa adminuser@192.73.20.123

* To prepare Ansible please start following these commands so Ansible can communicate to Azure. Alternatively you can run the ansible-ssh-automation.sh script in the repository.

         mkdir ~/.azure
         
         nano ~/.azure/credentials

* Input Azure Service Principle Values into these below located in the ~/.azure/credentials directory.

        [default]

        subscription_id=<your-Azure-subscription_id>

        client_id=<azure service-principal-appid>

        secret=<azure service-principal-password>

        tenant=<azure serviceprincipal-tenant> 

* You can create your SSH keys using the commands below or by using the ssh shell script in this repository.

      ssh-keygen -t rsa
      chmod 755 ~/.ssh
      touch ~/.ssh/authorized_keys
      chmod 644 ~/.ssh/authorized_keys
      ssh-copy-id adminuser@127.0.0.1
      
 * Input account password value
      
        cat ~/.ssh/id_rsa

### [↑](#contents) Create SSH Service Connection in Azure DevOps

* Create the Service Connection to allow SSH Connection and push Ansible Playbooks to the Virtual Machine
    
1. https://dev.azure.com/ > Project > Project Settings > Service Connections > Select : New Service Connection > Select : SSH
    
2. Add SSH Service Connection > Input Values : Public IP, Username, Password, id_rsa you cat eariler > OK.

### [↑](#contents) Run the Shell Scripts

* Git clone my bash script from https://github.com/DFW1N/terraform-ansible-azure
 
        git clone https://github.com/DFW1N/terraform-ansible-azure.git && cd terraform-ansible-azure
        
        sudo chmod +x ansible-autosetup.sh
        sudo sh ansible-autosetup.sh

### [↑](#contents) Ansible Installation on Ubuntu Linux

* 1.0 Installing & Updating required packages for Ansible

      sudo apt-get update
      sudo Ansible only support Ubuntu Linux until version 16.

* 2.0 Adding the offical Ansible repository to APT database

      apt-add-repository ppa:ansible/ansible

* 3.0 Install Ansible

      sudo apt-get update
      sudo apt-get install ansible
    
* 4.0 Verify Ansible Installation Version

      ansible --version
      useradd -m -s /bin/bash -p ansible ansible
 
* 5.0 Once Ansible user account is created change user to Ansible

      su ansible
 
* 6.0 Lastly generate a SSH key to the Ansible user account
 
      ssh-keygen
      exit

### [↑](#contents) Ansible Tower Installation on Ubuntu Linux
* Ansible Tower Installation on Ubuntu Linux
1. Access the Ansible website and Download the Ansible Tower product [https://www.ansible.com/products/tower]

* Assumation that the ansible-tower-setup-latest.tar.gz package is located inside the /tmp directory please follow commands in order:

      cd /tmp
      tar -zxvf ansible-tower-setup-latest.tar.gz [Ansible Tower Download File]
      cd /tmp/ansible-tower-setup{version}
      vi inventory
   
* Inventory file contents:

      [tower]
      localhost ansible_connection=local

      [database]

      [all:vars]
      admin_password=''

      pg_host=''
      pg_port=''

      pg_database='awx'
      pg_username='awx'
      pg_password=''

      rabbitmq_username=tower
      rabbitmq_password=''
      rabbitmq_cookie=cookiemonster

* Isolated Tower nodes automatically generate an RSA key for authentication;
* To disable this behavior, set this value to false
* isolated_key_generation=true
 
### [↑](#contents) Changing the following values from the inventory file:

        admin_password=''
        pg_password=''
        rabbitmq_password=''
        
 * Once values have been changed start Ansible Tower installation process:
 
        cd /tmp/ansible-tower-setup{version}
        ./setup.sh
    
 * On completion of installation open browser and enter IP address of your Ansible tower.
    
 * To log in use the 'default' username: admin and input the password you set above under the 
      
        [admin_password='input value']

### [↑](#contents) Review Ansible Playbooks for Azure
 
* https://docs.microsoft.com/en-us/samples/azure-samples/ansible-playbooks/ansible-playbooks-for-azure/

### [↑](#contents) Push Configurations to Remote Virtual Machines from Main Ansible Node Connector

* Follow the SSH requirements above and do the following : 

      ssh-copy-id {admin_user}@{Remote_VM_IP} //Example: ssh-copy-id root@192.70.109.15
    
* Input host password hit enter to add the public key you can now authenticate without being requested for a password.
* Define your remote hosts through the following file : 

      vim /etc/ansible/hosts > [webservers]
                               {remote host IP address}
                               {//Example 192.70.109.15}
                                
* creating a file that instructs all servers to connect as root user : 
   
      sudo mkdir /etc/ansible/group_vars && sudo nano /etc/ansible/group_vars/servers
      
* Input the following : 

               ----------------------------------------
                        ansible_user: root
               ----------------------------------------


* Test remote host by pinging from ansible with the following command : 

      ansible -m ping all
    
* Ping remote hosts defined under your configuration such as [databases] :

      ansible -m ping databases
    
* Check remote system versions :

      ansible -u root -i /etc/ansible/hosts -m raw -a 'uname -a' databases

### [↑](#contents) Notes 
* Ansible Tower only support Ubuntu Linux until version 16.04
* If you deploy my ansible-autosetup.sh bash script it will automatically give ansible-ssh-automation.sh the correct permissions to start the SSH process.
* Ansible Tower does not offer support to Ubuntu version 18 or 19.
* Ansible Tower Default Username : admin
* Use command : terraform fmt | To Fix spacing in your code.
  
### [↑](#support) Support
Please Support me if this has helped you with rapid infratructure deployment by following me on Twitter or connecting with me on LinkedIn feel free to visit my LinkedIin at [Linkedin](https://www.linkedin.com/in/sacha-roussakis-notter-b6903095/). I hope this has helped please do not use this script for any illegal purposes, this script was solely written for educational purposes or to help DevOps produce virtual machines on Azure at a rapid rate


[<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/logo-twitter-circle-png-transparent-image-1.png" align="left" width="30">](https://twitter.com/sacha_roussakis/)  [![Follow Sacha Roussakis | Sacha on Twitter](https://img.shields.io/twitter/follow/Sacha.svg?style=social&label=Follow%20%40Sacha)](https://twitter.com/intent/user?screen_name=sacha_roussakis "Follow Sacha Roussakis | Sacha on Twitter")

[<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/linkedin_circle-512.png" align="left" width="30">](https://www.linkedin.com/in/sacha-roussakis-notter-b6903095/) [@Sacha Roussakis-Notter](https://www.linkedin.com/in/sacha-roussakis-notter-b6903095/)

### [↑](#bugs) Bugs or Errors: 

#### Any Errors or Bugs feel free to make a Pull Request or Submit Issue.
- Free to pull-request clean up or add new modules or clean up the code in general. 
