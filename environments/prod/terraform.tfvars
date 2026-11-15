environment = "prod"
location    = "eastus2"

resource_groups = {
  "sec" = {
    name     = "rg-prod-sec-eastus2-01"
    location = "eastus2"
    tags = {
      Environment = "prod"
      Tier        = "Security"
      Compliance  = "PCI-DSS-HIPAA"
    }
  }
  "compute" = {
    name     = "rg-prod-compute-eastus2-01"
    location = "eastus2"
    tags = {
      Environment = "prod"
      Tier        = "Compute"
      Compliance  = "PCI-DSS-HIPAA"
    }
  }
}

vnets = {
  "compute" = {
    name                = "vnet-prod-compute-eastus2-01"
    location            = "eastus2"
    resource_group_name = "rg-prod-compute-eastus2-01"
    address_space       = ["172.20.0.0/16"]
    tags = {
      Environment = "prod"
      Role        = "Compute"
      Compliance  = "PCI-DSS-HIPAA"
    }
  }
}

subnets = {
  "vmss" = {
    name                = "snet-prod-vmss-01"
    vnet_key            = "compute"
    resource_group_name = "rg-prod-compute-eastus2-01"
    prefix              = "172.20.1.0/24"
  }
}

key_vault_sku     = "premium"
vm_admin_username = "corpadmin"
vm_admin_password = "Pr0dEnterpriseSecureP@ssw0rd2026!#"
vmss_sku          = "Standard_D4s_v5"
vmss_instances    = 4

common_tags = {
  Environment = "prod"
  ManagedBy   = "Terraform"
  Project     = "Corporate-VMSS-Platform"
  Compliance  = "PCI-DSS-HIPAA"
}

