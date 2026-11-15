environment = "dev"
location    = "eastus2"

resource_groups = {
  "sec" = {
    name     = "rg-dev-sec-eastus2-01"
    location = "eastus2"
    tags = {
      Environment = "dev"
      Tier        = "Security"
    }
  }
  "compute" = {
    name     = "rg-dev-compute-eastus2-01"
    location = "eastus2"
    tags = {
      Environment = "dev"
      Tier        = "Compute"
    }
  }
}

vnets = {
  "compute" = {
    name                = "vnet-dev-compute-eastus2-01"
    location            = "eastus2"
    resource_group_name = "rg-dev-compute-eastus2-01"
    address_space       = ["10.10.0.0/16"]
    tags = {
      Environment = "dev"
      Role        = "Compute"
    }
  }
}

subnets = {
  "vmss" = {
    name                = "snet-dev-vmss-01"
    vnet_key            = "compute"
    resource_group_name = "rg-dev-compute-eastus2-01"
    prefix              = "10.10.1.0/24"
  }
}

key_vault_sku     = "standard"
vm_admin_username = "azureuser"
vm_admin_password = "P@ssw0rdDevVmssEnterprise2026!"
vmss_sku          = "Standard_B2s"
vmss_instances    = 2

common_tags = {
  Environment = "dev"
  ManagedBy   = "Terraform"
  Project     = "Corporate-VMSS-Platform"
}

