variable "rg_name" {
  type        = string
  default     = "rg"
  description = "Name of the resource group."
}

variable "rg_location" {
  type        = string
  default     = "north europe"
  description = "Location of the resource group."
}

variable "vnet_name" {
  type        = string
  default     = "vnet"
  description = "Name of the Virtual Network."
}

variable "vnet_address_space" {
  type        = string
  default     = "north europe"
  description = "Address Space of the Virtual Network."
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "nic_name" {
  type        = string
  description = "Name of the Network Interface."
}

variable "vm_name" {
  type        = string
  description = "Name of the Virtual Machine."
}

variable "vm_size" {
  type        = string
  description = "Size of the Virtual Machine."
}

variable "kv_name" {
  type        = string
  description = "Name of the Key Vault."
}

variable "kv_sku" {
  type        = string
  description = "Key Vault sku."
}

variable "pip_name" {
  type        = string
  description = "Name of the Public Ip."
}

variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group."
}