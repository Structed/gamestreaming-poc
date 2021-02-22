variable "rg" {
  description = "The resource group in which to deploy the VM"
}

variable "subnet" {
  description = "The subnet to which the VM's nic shall be added"
}

variable "prefix" {
    type = string
    description = "Resource Name prefix"
}