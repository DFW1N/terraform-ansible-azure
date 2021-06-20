## Name Prefix for Resources
variable "prefix" {
  description = "The prefix which should be used for all resources in this deployment"
  default     = "LTF-Ansible"
}

## Location Variable
variable "location" {
  description = "The Azure Region in which all resources in this deployment should be created."
  default     = "australiaeast"
}

## Location Variable
variable "anisbletower" {
  description = "The name of resources for ansible that should be created on this deployment."
  default     = "ansible-tower"
}

## Administrator Username Variable
variable "linuxuser" {
  description = "The linux username for this deployment."
  default     = "adminuser"
}

variable "linuxpwd" {
  description = "The linux pwd for this deployment."
  default     = "UnicornJumpedth3br1dg34000!"
}

## Network Security Group Allowed Port Variable
variable "approvedport" {
  description = "The SSH port to allow connection deployment."
  default     = "22"
}
