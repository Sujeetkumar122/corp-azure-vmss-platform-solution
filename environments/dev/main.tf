# ==============================================================================
# Linux VMSS Platform Orchestration - Development
# ==============================================================================

# 1. Resource Groups
module "resource_groups" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

# 2. Virtual Networks & Subnets
module "virtual_networks" {
  source     = "../../modules/azurerm_virtual_network"
  vnets      = var.vnets
  subnets    = var.subnets
  depends_on = [module.resource_groups]
}

# 3. Key Vault Platform Security (Secure Credentials)
module "key_vaults" {
  source = "../../modules/azurerm_key_vault"
  key_vaults = {
    "sec-kv" = {
      name                       = "kv-${var.environment}-vmss-plat-01"
      location                   = var.location
      resource_group_name        = module.resource_groups.resource_group_names["sec"]
      tenant_id                  = data.azurerm_client_config.current.tenant_id
      sku_name                   = var.key_vault_sku
      soft_delete_retention_days = 7
      purge_protection_enabled   = true
      tags                       = var.common_tags
    }
  }
  key_vault_secrets = {
    "vmss-pwd" = {
      name         = "${var.environment}-vmss-admin-password"
      value        = var.vm_admin_password
      key_vault_id = module.key_vaults.key_vault_ids["sec-kv"]
      tags         = var.common_tags
    }
  }
  depends_on = [module.resource_groups]
}

# 4. Linux Virtual Machine Scale Set (VMSS)
module "scale_sets" {
  source = "../../modules/azurerm_linux_virtual_machine_scale_set"
  scale_sets = {
    "app-vmss" = {
      name                 = "vmss-${var.environment}-app-01"
      resource_group_name  = module.resource_groups.resource_group_names["compute"]
      location             = var.location
      sku                  = var.vmss_sku
      instances            = var.vmss_instances
      admin_username       = var.vm_admin_username
      admin_password       = var.vm_admin_password
      subnet_id            = module.virtual_networks.subnet_ids["vmss"]
      storage_account_type = "Standard_LRS"
      tags                 = var.common_tags
    }
  }
  depends_on = [module.virtual_networks, module.key_vaults]
}

