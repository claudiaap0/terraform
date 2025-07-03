# RG
resource "azurerm_resource_group" "my_resource_group" {
  name     = var.rg_name
  location = var.rg_location
  tags = local.tags
}

# Virtual Network
resource "azurerm_virtual_network" "my_vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  address_space       = [var.vnet_address_space]
  tags = local.tags
}

# Subnet
resource "azurerm_subnet" "my_subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = each.value.address_prefixes
}

# Network Interface
resource "azurerm_network_interface" "my_nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  tags = local.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my_subnets["subnet1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_pip.id

  }
}

# Public Ip
resource "azurerm_public_ip" "my_pip" {
  name                = var.pip_name
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  allocation_method   = "Static"
  tags = local.tags
}

# Key Vault
resource "azurerm_key_vault" "my_kv" {
  name                       = var.kv_name
  location                   = azurerm_resource_group.my_resource_group.location
  resource_group_name        = azurerm_resource_group.my_resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku
  soft_delete_retention_days = 7
  tags = local.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "List",
      "Get",
      "Delete",
      "Purge",
      "Recover"
    ]
  }
}

# Key Vault Secret
resource "azurerm_key_vault_secret" "ssh_pub_key" {
  name         = "my-ssh-key"
  value        = file("~/.ssh/id_rsa.pub")
  key_vault_id = azurerm_key_vault.my_kv.id
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "my_linux" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = azurerm_resource_group.my_resource_group.location
  size                = var.vm_size
  admin_username      = "capostu"
  tags = local.tags

  admin_ssh_key {
  username   = "capostu"
  public_key = data.azurerm_key_vault_secret.ssh_key.value
  }
  
  network_interface_ids = [
    azurerm_network_interface.my_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Network Security Group
resource "azurerm_network_security_group" "my_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.my_resource_group.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  tags = local.tags

  security_rule {
    name                       = "Allow-SSH-Inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

# Network Security Group association
resource "azurerm_network_interface_security_group_association" "my_nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.my_nic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}
