rg_name = "rg-ne-training"
rg_location = "North Europe"

vnet_name = "rg-ne-training-vnet"
vnet_address_space = "10.1.0.0/16"

subnets = {
  subnet1 = {
    name             = "rg-ne-training-snet1"
    address_prefixes = ["10.1.0.0/24"]
  },
  subnet2 = {
    name             = "rg-ne-training-snet2"
    address_prefixes = ["10.1.1.0/29"]
  }
}

nic_name = "rg-ne-training-nic"

vm_name = "rg-ne-training-vm"
vm_size = "Standard_B1s"

kv_name = "rg-ne-training-kv"
kv_sku = "standard"

pip_name = "rg-ne-training-pip"

nsg_name = "rg-ne-training-nsg"

vms = {
  vm1 = {
    vm_size     = "Standard_B1s"
    subnet_name = "subnet1"
  }
  vm2 = {
    vm_size     = "Standard_B1s"
    subnet_name = "subnet2"
  }
}
