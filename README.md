# Author : Sacha Roussakis-Notter
# Date : 20/06/2021
# Coding Language : Hashicorp Language [HCL] & Shell [SH]

## Notes 
    1. Ansible Tower only support Ubuntu Linux until version 16.04
    2. If you deploy my ansible-autosetup.sh bash script it will automatically give ansible-ssh-automation.sh the correct permissions to start the SSH process.
    3. Ansible Tower does not offer support to Ubuntu version 18 or 19.
    4. Prerequisites : Azure CLI [https://docs.microsoft.com/en-us/cli/azure/install-azure-cli], PowerShell [https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell], Terraform [https://learn.hashicorp.com/tutorials/terraform/install-cli] & Visual Studio Code [https://code.visualstudio.com/download] with HashiCorp Terraform Extension [https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform].
    # Ansible Tower Default Username : admin
    # Use command : terraform fmt | To Fix spacing in your code.


# File Structure
    1. main.tf [infrastructure as code]
    2. provider.tf [service principle exports]
    3. variables.tf [infrastructure deployment variables]
    4. ansible-autosetup.sh [requires manual set up of ssh or using the ansible-ssh-automation shell script]
    5. ansible-ssh-automation.sh [Ensure you follow the prompts to correctly do it without doing it manually]
    6. README.md [File to help guide people through the installation process and explains the current repository]
    7. credentials [A file that has the values for your Azure Service Principle for Authentication]

# main.tf
    1. Linux Virtual Machine Ansible Main Node [Ubuntu 16.04]
    2. Virtual Network Interfaces [x2]
    3. Azure Network Security Group Association [x1]
    4. Azure Network Security Group
    5. Azure Public IP Adress [x1]
    6. Azure Subnet Internal
    7. Azure Resource Group
    8. Azure Virtual Network

## Terraform Deployment Template Setup for Ansible Tower
    # This template has been created for the purpose of deploying a Linux VM to Azure, using Terraform Infrastructure as Code to automatically provision an environment to deploy Ansible or Ansible Tower to a Enterprise environment rapidly and in an automated matter. This infrastructure has been written by Sacha Roussakis-Notter you can view more at: https://github.com/DFW1N/.

# 1.0 Create a Service Principal with a Client Secret
    # Please Review for Hashicorp Guide for Azure Service Principal Authentication
    1. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

# 1.1 Connecting Terraform to there remote servers at app.terraform.io
    1. Register an account at : https://app.terraform.io/ [Recommend enabling MFA] > Create Organization > [+ New workspace]
    2. Ensure, Azure CLI, Powershell & Terraform are installed in Visual Studio Code open Terminal type : terraform login
    3. Follow terminal prompts and creare a API token to authenticate with copy and paste code to your terminal once authenticated.
    4. Input backend remote code into your provider.tf file

                        terraform {
                    backend "remote" {
                        organization = "organization-value-name"

                        workspaces {
                        name = "workstation-value-name-you-set"
                        }
                    }
                    } 

# 1.2 Export Service Provider Values to your System Environment Variables/Configuring the Service Principal in Terraform
    # Setting these values into your environment variable allows you to remove them from your code as these are SECRET and should not be shared.
    # Once these variables are set restart your terminal and Visual Studio Code to allow it to take effect.
    setx ARM_CLIENT_ID "00000000-0000-0000-0000-000000000000"
    setx ARM_CLIENT_SECRET "00000000-0000-0000-0000-000000000000"
    setx ARM_SUBSCRIPTION_ID "00000000-0000-0000-0000-000000000000"
    setx ARM_TENANT_ID "00000000-0000-0000-0000-000000000000"

# 2.0 Create a Terraform Ubuntu Linux Virtual Machine for Ansible
    1. What is Terraform? https://www.terraform.io/
    2. What is Azure? https://azure.microsoft.com/en-us/
    3. What is Ansible? https://www.ansible.com/
    4. What is Bash Script? https://ryanstutorials.net/bash-scripting-tutorial/bash-script.php

# 3.0 Create a Azure Local Blob Storage Account Container for tfstate Backend File

# 4.0 Deploy Terraform infrastructure
    # Completing the following steps 1 to 10 allows for Ansible to have SSH authentication and create a SSH service connection in Azure DevOps
    1. Connect to Virtual Machine Public IP Address [ssh -i ~/.ssh/id_rsa adminuser@public.ip.address]
    2. mkdir ~/.azure
    3. nano ~/.azure/credentials
    4. |

[default]

subscription_id=<your-Azure-subscription_id>

client_id=<azure service-principal-appid>

secret=<azure service-principal-password>

tenant=<azure serviceprincipal-tenant>  |

    5. ssh-keygen -t rsa
    6. chmod 755 ~/.ssh
    7. touch ~/.ssh/authorized_keys
    8. chmod 644 ~/.ssh/authorized_keys
    9. ssh-copy-id adminuser@127.0.0.1
    10. Input account password value
    11. cat ~/.ssh/id_rsa

# 5.0 Create SSH Service Connection in Azure DevOps
    # Create the Service Connection to allow SSH Connection and push Ansible Playbooks to the Virtual Machine
    1. https://dev.azure.com/ > Project > Project Settings > Service Connections > Select : New Service Connection > Select : SSH
    2. Add SSH Service Connection > Input Values : Public IP, Username, Password, id_rsa you cat eariler > OK.

# Run my BashScript [Optional]
    # Git clone my bash script from https://github.com/DFW1N/terraform-ansible-azure
    1. git clone https://github.com/DFW1N/terraform-ansible-azure.git && cd ansible-tower
    3. sudo chmod +x ansible-autosetup.sh
    4. sudo sh ansible-autosetup.sh


# 6.0 Ansible Installation on Ubuntu Linux [Without Bash Script]
    # Installing & Updating required packages for Ansible
    1. sudo apt-get update
    2. sudo Ansible only support Ubuntu Linux until version 16.
    # Adding the offical Ansible repository to APT database
    3. apt-add-repository ppa:ansible/ansible
    # Install Ansible
    4. sudo apt-get update
    5. sudo apt-get install ansible
    # Verify Ansible Installation Version
    6. ansible --version
    7. useradd -m -s /bin/bash -p ansible ansible
    # Once Ansible user account is created change user to Ansible
    8. su ansible
    # Lastly generate a SSH key to the Ansible user account
    9. ssh-keygen
    10. exit

# 6.1 Ansible Tower Installation on Ubuntu Linux
    # Ansible Tower Installation on Ubuntu Linux
    1. Access the Ansible website and Download the Ansible Tower product [https://www.ansible.com/products/tower]
    # Assumation that the ansible-tower-setup-latest.tar.gz package is located inside the /tmp directory please follow commands in order:
    2. cd /tmp
    3. tar -zxvf ansible-tower-setup-latest.tar.gz [Ansible Tower Download File]
    4. cd /tmp/ansible-tower-setup{version}
    5. vi inventory
    # Cat Value of file: |

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

# Isolated Tower nodes automatically generate an RSA key for authentication;
# To disable this behavior, set this value to false
# isolated_key_generation=true
    |
    # Please change the following values from the inventory file:
    6.  admin_password=''
        pg_password=''
        rabbitmq_password=''
    # Once values have been changed start Ansible Tower installation process:
    7. cd /tmp/ansible-tower-setup{version}
    8. ./setup.sh
    9. On completion of installation open browser and enter IP address of your Ansible tower.
    # To log in use the 'default' username: admin and input the password you set above under the [admin_password='input value']

# 7.0 Review Ansible Playbooks
    1. https://docs.microsoft.com/en-us/samples/azure-samples/ansible-playbooks/ansible-playbooks-for-azure/

# 8.0 Push Configurations to Remote Virtual Machines from Main Ansible Node
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
