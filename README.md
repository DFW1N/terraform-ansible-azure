  <a target="_blank" href="HCL" title="HCL: Hashicorp Language"><img src="https://img.shields.io/badge/HashiCorp-HCL-red.svg"></a>
  <a target="_blank" href="https://www.python.org/downloads/" title="Python version"><img src="https://img.shields.io/badge/python-%3E=_3.5-yellow.svg"></a>
  ![OS](https://img.shields.io/badge/Written%20in-Shell-orange.svg?style=flat-square)

## [↑](#contents) Credits
Contributor:                                                [<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/DFW1N%20Logo.png" align="right" width="120">](https://github.com/DFW1N/DFW1N-OSINT)

- [Sacha Roussakis-Notter](https://github.com/DFW1N)

 [![Follow Sacha Roussakis | Sacha on Twitter](https://img.shields.io/twitter/follow/Sacha.svg?style=social&label=Follow%20%40Sacha)](https://twitter.com/intent/user?screen_name=sacha_roussakis "Follow Sacha Roussakis | Sacha on Twitter")

## [↑](#contents) Providers

- [Terraform](https://www.terraform.io/)
- [Microsoft](https://azure.microsoft.com/en-au/)
- [Ansible](https://www.ansible.com/)
- [RedHat](https://www.redhat.com/en)


## 📖 Table of Contents
- [Introduction](#-introduction)
- [File Structure](#-file-structure)
- [What is Terraform](#-what-is-terraform)
- [Terraform Deployment](#-terraform-deployment-template-setup-for-ansible)
- [Deploy Terraform infrastructure commands](#-deploy-terraform-infrastructure-commands)
- [Connecting to Terraform Cloud Remote Backend](#-connecting-to-terraform-cloud-remote-backend)
- [Connecting Terraform to there remote servers at app.terraform.io](#-connecting-terraform-to-there-remote-servers)
- [Create a Azure local blob storage account Container for tfstate backend file](#-create-a-azure-local-blob-storage-account-Container-for-tfstate-backend-file)
- [Create a Service Principal with a Client Secret](#-create-a-service-principal-with-a-client-secret)
- [Configuring the Service Principal in Terraform](#-configuring-the-service-principal-in-terraform)
- [Create SSH Service Connection in Azure DevOps](#-create-ssh-service-connection-in-azure-devops)
- [Run the Shell Scripts](#-run-the-shell-scripts)
- [Ansible Installation on Ubuntu Linux [Without Bash Script]](#-snsible-installation-on-ubuntu-linux)
- [Configure Ansible to run as a specific user](#-configure-ansible-to-run-as-a-specific-user)
- [Review Ansible Playbooks for Azure](#-review-ansible-playbooks-for-azure)
- [Ansible Tower Installation on Ubuntu Linux](#-ansible-tower-installation-on-ubuntu-linux)
- [Deployment Notes](#-notes)
- [Support](#-support)
- [Bugs & Errors](#-bugs-or-errors)

### [↑](#contents) Introduction

Terraform automation to create a virtual machine with Ubuntu 16.04 and using custom bash scripts to automate the setup for ansible to control and push configurations to remote hosts on Microsoft Azure.

#### Ansible Glossary:
The following Ansible-specific terms that are used throughout this guide include the following:

* Inventory File: a file that contains information about the servers Ansible controls, typically located at /etc/ansible/hosts.
* Playbook: a file containing a series of tasks to be executed on a remote server.
* Remote Host/Node: a server controlled by the Ansible server.
* Ansible Server: a system where Ansible is installed and configured to connect and execute commands on remote hosts/nodes.

1. Prerequisites : 

    - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
    - [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
    - [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
    - [Visual Studio Code](https://code.visualstudio.com/download)
    - [HashiCorp Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
    - [Azure DevOps](http://dev.azure.com/)
    

### [↑](#contents) File Structure
- [main.tf](https://github.com/DFW1N/terraform-ansible-azure/blob/main/main.tf) [infrastructure as code]
- [provider.tf](https://github.com/DFW1N/terraform-ansible-azure/blob/main/provider.tf) [service principle exports]
- [variables.tf](https://github.com/DFW1N/terraform-ansible-azure/blob/main/variables.tf) [infrastructure deployment variables]
- [autosetup.sh](https://github.com/DFW1N/terraform-ansible-azure/blob/main/autosetup.sh) [automates commands needed to install ansible and generate ssh key]
- [README.md](https://github.com/DFW1N/terraform-ansible-azure/blob/main/README.md) [File to help guide people through the installation process and explains the current repository]
- [credentials](https://github.com/DFW1N/terraform-ansible-azure/blob/main/credentials) [A file that has the values for your Azure Service Principle for Authentication]

### [↑](#contents) What is Terraform
* What is Terraform? https://www.terraform.io/
* What is Azure? https://azure.microsoft.com/en-us/
* What is Ansible? https://www.ansible.com/
* What is Bash Script? https://ryanstutorials.net/bash-scripting-tutorial/bash-script.php

### [↑](#contents) Terraform Deployment Template Setup for Ansible
* This template has been created for the purpose of deploying a Linux VM to Azure, using Terraform Infrastructure as Code to automatically provision an environment to deploy Ansible or Ansible Tower to a Enterprise environment rapidly and in an automated matter.

### [↑](#contents) Deploy Terraform infrastructure commands

* Note: You can find the latest Terraform code templates at : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
* Templates: You can view Terraform code examples at : https://github.com/terraform-providers/terraform-provider-azurerm/tree/master/examples

* To deploy Terraform you must change some current values in the files but the main commands to Initialize, Plan, Build & Deploy it to Azure are the following :

      terraform init
      terraform fmt
      terraform plan
      terraform apply
      terraform destroy

    
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

* Preview of using local CLI commands using Terraform Cloud : 

![image](https://user-images.githubusercontent.com/45083490/122667564-c27c0600-d1f6-11eb-9734-1b54dd26f138.png)

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

### [↑](#contents) Create a Service Principal with a Client Secret
* Please Review for Hashicorp Guide for Azure Service Principal Authentication
    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

### [↑](#contents) Configuring the Service Principal in Terraform
* Setting these values into your environment variable allows you to remove them from your code as these are SECRET and should not be shared.
* Once these variables are set restart your terminal and Visual Studio Code to allow it to take effect.

        setx ARM_CLIENT_ID "00000000-0000-0000-0000-000000000000"
        setx ARM_CLIENT_SECRET "00000000-0000-0000-0000-000000000000"
        setx ARM_SUBSCRIPTION_ID "00000000-0000-0000-0000-000000000000"
        setx ARM_TENANT_ID "00000000-0000-0000-0000-000000000000"
 
* Once the infrastructure has been deployed locate the public ip address and connect to the vm through ssh :
        
         ssh -i ~/.ssh/id_rsa adminuser@192.73.20.123

### [↑](#contents) Create SSH Service Connection in Azure DevOps

* Create the Service Connection to allow SSH Connection and push Ansible Playbooks to the Virtual Machine
    
1. https://dev.azure.com/ > Project > Project Settings > Service Connections > Select : New Service Connection > Select : SSH
    
2. Add SSH Service Connection > Input Values : Public IP, Username, Password, id_rsa you cat eariler > OK.

### [↑](#contents) Run the Shell Script

* Git clone my bash script from https://github.com/DFW1N/terraform-ansible-azure
 
        git clone https://github.com/DFW1N/terraform-ansible-azure.git && cd terraform-ansible-azure
        
        sudo chmod +x autosetup.sh
        sudo sh autosetup.sh

### [↑](#contents) Ansible Installation on Ubuntu Linux

* Please follow this section if you prefer to not use the shell script to automate the process for you.

#### 1.0: Installing & Updating required packages for Ansible:

      sudo apt-get upgrade -y

#### 2.0: Adding the offical Ansible repository to APT database:

      sudo apt-add-repository ppa:ansible/ansible

#### 3.0: Install Ansible:

      sudo apt-get update
      sudo apt-get install ansible -y
      sudo apt-get install python -y
    
#### 4.0: Verify Ansible Installation Version:

      ansible --version
 
#### 5.0: Create the files to allow Ansible Server to authenticate with Azure: [Azure only]

      mkdir ~/.azure && cd ~/.azure;
      sudo curl https://raw.githubusercontent.com/DFW1N/ansible-tower/main/credentials -o credentials;

* Input Azure Service Principle Values into these below located in the ~/.azure/credentials directory: [Azure only]

        [default]

        subscription_id=<your-Azure-subscription_id>

        client_id=<azure service-principal-appid>

        secret=<azure service-principal-password>

        tenant=<azure serviceprincipal-tenant> 
 
#### 6.0: Lastly generate a SSH key to the Ansible server:
 
      ssh-keygen
      cat ~/.ssh/id_rsa.pub
 
#### 7.0: Copy id_rsa.pub to remote server you want to connect to your Ansible server:

* Option 1 Quick Version: Issue this command from Ansible Server to remote host:

      sudo ssh-copy-id 192.182.16.23

* Password prompt for remote host will pop up input that value to add the ssh id_rsa.pub to remote host.

* Option 2 Longer Version:

      Copy the text from the key
      Log into your node server
      run: sudo -s
      Open the authorized_keys file: sudo nano ~/.ssh/authorized_keys
      Paste the id_rsa.pub key to the file from your Ansible server
      Save and close the file
 
 * Please ensure you are logged in as root to view authorized_keys as it won't be located anywhere else but under the /root/ home directory.
 
#### 8.0: Configure your Ansible files:
Please ensure you are logged in on your Ansible server and configure Ansible files for remote hosts:

      sudo nano /etc/ansible/hosts
      
* Add your remote servers to this file using the following syntax:

* The following example defines a group named [azureservers] with two different servers in it, each identified by a custom alias: azureserver & azureserver2 remmeber to change the IP address to your remote hosts.

      [azureservers]
      azureserver ansible_host=192.182.16.23
      azureserver2 ansible_host=192.173.34.23

      [all:vars]
      ansible_python_interpreter=/usr/bin/python3

* View your ansible inventory you will see your server infrastructure thats defined in your inventory file on your Ansible server:

      ansible-inventory --list -y

* Output
      
      all:
        children:
          azureservers:
            hosts:
              azureserver:
                ansible_host: 192.182.16.23
                ansible_python_interpreter: /usr/bin/python3
              azureserver2:
                ansible_host: 192.173.34.23
                ansible_python_interpreter: /usr/bin/python3

#### 9.0: Test your Ansible Connection:

* Test remote host by pinging from ansible with the following command : 

      ansible -m ping all

* Expected output response:

      azureserver | SUCCESS => {
          "changed": false, 
          "ping": "pong"
      }
      azureserver2 | SUCCESS => {
      "changed": false, 
      "ping": "pong"
      }
    
* Ping remote hosts defined under your configuration such as [databases] :

      ansible -m ping databases
    
* Check remote system versions :

      ansible -u adminuser -i /etc/ansible/hosts -m raw -a 'uname -a' azureservers

* Check disk usage on all remote servers with:

      ansible all -a "df -h" -u adminuser

### [↑](#contents) Configure Ansible to run as a specific user:

* creating a file that instructs all servers to connect as root user : 
   
      sudo mkdir /etc/ansible/group_vars && sudo nano /etc/ansible/group_vars/servers
      
* Input the following username used on the remote host: 

       ansible_ssh_user: adminuser

### [↑](#contents) Review Ansible Playbooks for Azure

* Playbook: A file containing a series of tasks to be executed on a remote server.
* https://docs.microsoft.com/en-us/samples/azure-samples/ansible-playbooks/ansible-playbooks-for-azure/


### [↑](#contents) Ansible Tower Installation on Ubuntu Linux
* Ansible Tower Installation on [Ubuntu Linux](https://ubuntu.com/)
1. Access the [Ansible](https://www.ansible.com) website and Download the [Ansible Tower product](https://www.ansible.com/products/tower)

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
 
### Changing the following values from the inventory file for Ansible Tower:

        admin_password=''
        pg_password=''
        rabbitmq_password=''
        
 * Once values have been changed start Ansible Tower installation process:
 
        cd /tmp/ansible-tower-setup{version}
        ./setup.sh
    
 * On completion of installation open browser and enter IP address of your Ansible tower.
    
 * To log in use the 'default' username: admin and input the password you set above under the 
      
        [admin_password='input value']

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
