locals{

    tags = {
    "Owner" = "capostu"
    }
}

data "azurerm_key_vault_secret" "ssh_key" {
  name         = "my-ssh-key"
  key_vault_id = azurerm_key_vault.my_kv.id
}