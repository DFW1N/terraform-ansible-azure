  <a target="_blank" href="HCL" title="HCL: Hashicorp Language"><img src="https://img.shields.io/badge/HashiCorp-HCL-red.svg"></a>
  <a target="_blank" href="https://www.python.org/downloads/" title="Python version"><img src="https://img.shields.io/badge/python-%3E=_3.5-yellow.svg"></a>
  ![OS](https://img.shields.io/badge/Written%20in-Shell-orange.svg?style=flat-square)

## [↑](#contents) Credits
Contributor:                                                [<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/DFW1N%20Logo.png" align="right" width="120">](https://github.com/DFW1N/DFW1N-OSINT)

- [Sacha Roussakis-Notter](https://github.com/DFW1N)

 [![Follow Sacha Roussakis | Sacha on Twitter](https://img.shields.io/twitter/follow/Sacha.svg?style=social&label=Follow%20%40Cimol)](https://twitter.com/intent/user?screen_name=sacha_roussakis "Follow Sacha Roussakis | Sacha on Twitter")

## 📖 Table of Contents
- [Introduction](#-introduction)
- [File Structure](#-file-structure)


## [↑](#contents) Introduction

### Notes 
1. Ansible Tower only support Ubuntu Linux until version 16.04
2. If you deploy my ansible-autosetup.sh bash script it will automatically give ansible-ssh-automation.sh the correct permissions to start the SSH process.
3. Ansible Tower does not offer support to Ubuntu version 18 or 19.
4. Prerequisites : 
    * Azure CLI [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli]
    * PowerShell [https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell]
    * Terraform [https://learn.hashicorp.com/tutorials/terraform/install-cli]
    * Visual Studio Code [https://code.visualstudio.com/download
    * HashiCorp Terraform Extension [https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform]
    
6. Ansible Tower Default Username : admin
7. Use command : terraform fmt | To Fix spacing in your code.


### [↑](#contents) File Structure
* main.tf [infrastructure as code]
* provider.tf [service principle exports]
* variables.tf [infrastructure deployment variables]
* ansible-autosetup.sh [requires manual set up of ssh or using the ansible-ssh-automation shell script]
* ansible-ssh-automation.sh [Ensure you follow the prompts to correctly do it without doing it manually]
* README.md [File to help guide people through the installation process and explains the current repository]
* credentials [A file that has the values for your Azure Service Principle for Authentication]

### [↑](#contents) main.tf
* Linux Virtual Machine Ansible Main Node [Ubuntu 16.04]
* Virtual Network Interfaces [x2]
* Azure Network Security Group Association [x1]
* Azure Network Security Group
* Azure Public IP Adress [x1]
* Azure Subnet Internal
* Azure Resource Group
* Azure Virtual Network

### [↑](#contents) Terraform Deployment Template Setup for Ansible
* This template has been created for the purpose of deploying a Linux VM to Azure, using Terraform Infrastructure as Code to automatically provision an environment to deploy Ansible or Ansible Tower to a Enterprise environment rapidly and in an automated matter. This infrastructure has been written by Sacha Roussakis-Notter you can view more at: [Github](https://github.com/DFW1N/).

### [↑](#contents) 1.0 Create a Service Principal with a Client Secret
* Please Review for Hashicorp Guide for Azure Service Principal Authentication
    https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

### [↑](#contents) 1.1 Connecting Terraform to there remote servers at app.terraform.io
* Register an account at : https://app.terraform.io/ [Recommend enabling MFA] > Create Organization > [+ New workspace]
* Ensure, Azure CLI, Powershell & Terraform are installed in Visual Studio Code open Terminal type : terraform login
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

### [↑](#contents) 1.2 Export Service Provider Values to your System Environment Variables/Configuring the Service Principal in Terraform
* Setting these values into your environment variable allows you to remove them from your code as these are SECRET and should not be shared.
* Once these variables are set restart your terminal and Visual Studio Code to allow it to take effect.

        setx ARM_CLIENT_ID "00000000-0000-0000-0000-000000000000"
        setx ARM_CLIENT_SECRET "00000000-0000-0000-0000-000000000000"
        setx ARM_SUBSCRIPTION_ID "00000000-0000-0000-0000-000000000000"
        setx ARM_TENANT_ID "00000000-0000-0000-0000-000000000000"

### [↑](#contents)  2.0 Create a Terraform Ubuntu Linux Virtual Machine for Ansible
* What is Terraform? https://www.terraform.io/
* What is Azure? https://azure.microsoft.com/en-us/
* What is Ansible? https://www.ansible.com/
* What is Bash Script? https://ryanstutorials.net/bash-scripting-tutorial/bash-script.php

### [↑](#contents) 3.0 Create a Azure Local Blob Storage Account Container for tfstate Backend File

* Using Azure Storage Container to store state file instead of remote backend from terraform

        terraform {
          backend "azurerm" {
            resource_group_name  = "Resource-Group-Name-Value"
            storage_account_name = "Account-Name-Value"
            container_name       = "tfstate"
            key                  = "00000000-0000-0000-0000-000000000000"
          }
        }

### [↑](#contents) 4.0 Deploy Terraform infrastructure
* Completing the following steps 1 to 10 allows for Ansible to have SSH authentication and create a SSH service connection in Azure DevOps
1. Connect to Virtual Machine Public IP Address [ssh -i ~/.ssh/id_rsa adminuser@public.ip.address]
2. mkdir ~/.azure
3. nano ~/.azure/credentials

    [default]

    subscription_id=<your-Azure-subscription_id>

    client_id=<azure service-principal-appid>

    secret=<azure service-principal-password>

    tenant=<azure serviceprincipal-tenant> 

    5. ssh-keygen -t rsa
    6. chmod 755 ~/.ssh
    7. touch ~/.ssh/authorized_keys
    8. chmod 644 ~/.ssh/authorized_keys
    9. ssh-copy-id adminuser@127.0.0.1
    10. Input account password value
    11. cat ~/.ssh/id_rsa

### [↑](#contents) 5.0 Create SSH Service Connection in Azure DevOps
* Create the Service Connection to allow SSH Connection and push Ansible Playbooks to the Virtual Machine
    1. https://dev.azure.com/ > Project > Project Settings > Service Connections > Select : New Service Connection > Select : SSH
    2. Add SSH Service Connection > Input Values : Public IP, Username, Password, id_rsa you cat eariler > OK.

### [↑](#contents) Run my BashScript [Optional]
    # Git clone my bash script from https://github.com/DFW1N/terraform-ansible-azure
    1. git clone https://github.com/DFW1N/terraform-ansible-azure.git && cd ansible-tower
    3. sudo chmod +x ansible-autosetup.sh
    4. sudo sh ansible-autosetup.sh


### [↑](#contents) 6.0 Ansible Installation on Ubuntu Linux [Without Bash Script]
* Installing & Updating required packages for Ansible
    1. sudo apt-get update
    2. sudo Ansible only support Ubuntu Linux until version 16.
* Adding the offical Ansible repository to APT database
    3. apt-add-repository ppa:ansible/ansible
* Install Ansible
    4. sudo apt-get update
    5. sudo apt-get install ansible
* Verify Ansible Installation Version
    6. ansible --version
    7. useradd -m -s /bin/bash -p ansible ansible
* Once Ansible user account is created change user to Ansible
    8. su ansible
* Lastly generate a SSH key to the Ansible user account
    9. ssh-keygen
    10. exit

### [↑](#contents) 6.1 Ansible Tower Installation on Ubuntu Linux
* Ansible Tower Installation on Ubuntu Linux
    1. Access the Ansible website and Download the Ansible Tower product [https://www.ansible.com/products/tower]
* Assumation that the ansible-tower-setup-latest.tar.gz package is located inside the /tmp directory please follow commands in order:
    2. cd /tmp
    3. tar -zxvf ansible-tower-setup-latest.tar.gz [Ansible Tower Download File]
    4. cd /tmp/ansible-tower-setup{version}
    5. vi inventory
* Cat Value of file: |

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
 
### [↑](#contents) Please change the following values from the inventory file:
    6.  admin_password=''
        pg_password=''
        rabbitmq_password=''
    # Once values have been changed start Ansible Tower installation process:
    7. cd /tmp/ansible-tower-setup{version}
    8. ./setup.sh
    9. On completion of installation open browser and enter IP address of your Ansible tower.
    
 * To log in use the 'default' username: admin and input the password you set above under the [admin_password='input value']

### [↑](#contents) 7.0 Review Ansible Playbooks
    1. https://docs.microsoft.com/en-us/samples/azure-samples/ansible-playbooks/ansible-playbooks-for-azure/

### [↑](#contents) 8.0 Push Configurations to Remote Virtual Machines from Main Ansible Node
    1. Follow the SSH requirements above and do the following : 
    2. ssh-copy-id {admin_user}@{Remote_VM_IP} //Example: ssh-copy-id root@192.70.109.15
    3. Input host password hit enter to add the public key you can now authenticate without being requested for a password.
    4. Define your remote hosts through the following file : 
    5. vim /etc/ansible/hosts > [webservers]
                                {remote host IP address}
                                {//Example 192.70.109.15}
    6. creating a file that instructs all servers to connect as root user : 
    7. sudo mkdir /etc/ansible/group_vars && sudo nano /etc/ansible/group_vars/servers
    8. Input the following : 
                        ----------
                        ansible_user: root

    9. Test remote host by pinging from ansible with the following command : 
    10. ansible -m ping all
    11. or ping remote hosts defined under your configuration such as [databases]
    12. ansible -m ping databases
    13. Check remote system versions : ansible -u root -i /etc/ansible/hosts -m raw -a 'uname -a' databases
   
## [↑](#support) Support
Please Support me if this has helped you with rapid infratructure deployment by following me on Twitter or connecting with me on LinkedIn feel free to visit my LinkedIin at [Linkedin](https://www.linkedin.com/in/sacha-roussakis-notter-b6903095/). I hope this has helped please do not use this script for any illegal purposes, this script was solely written for educational purposes or to help DevOps produce virtual machines on Azure at a rapid rate


[<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/logo-twitter-circle-png-transparent-image-1.png" align="left" width="30">](https://twitter.com/sacha_roussakis/)  [![Follow Sacha Roussakis | Sacha on Twitter](https://img.shields.io/twitter/follow/Sacha.svg?style=social&label=Follow%20%40Cimol)](https://twitter.com/intent/user?screen_name=sacha_roussakis "Follow Sacha Roussakis | Sacha on Twitter")

[<img src="https://github.com/DFW1N/DFW1N-OSINT/blob/master/linkedin_circle-512.png" align="left" width="30">](https://www.linkedin.com/in/sacha-roussakis-notter-b6903095/) [@Sacha Roussakis-Notter](https://www.linkedin.com/in/sacha-roussakis-notter-b6903095/)

## [↑](#bugs) Bugs/Errors: 

#### Any Errors or Bugs feel free to make a Pull Request or Submit Issue.
- Free to pull-request clean up or add new modules or clean up the code in general. 

## [↑](#lisence) Lisence: 

<a target="_blank" href="LICENSE" title="License: GNU General Public v3.0"><img src="https://img.shields.io/badge/License-GNU-red.svg"></a>
<a target="_blank" href="DEVELOPER" title="License: Script Developer"><img src="https://img.shields.io/badge/Developer-Sacha-brightgreen.svg"></a>
