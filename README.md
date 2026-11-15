# Corporate Azure Linux VMSS Platform Solution

## Overview
This repository provides an enterprise-grade **Azure Linux Virtual Machine Scale Sets (VMSS)** compute platform designed in accordance with the Microsoft Cloud Adoption Framework (CAF). It features multi-tier networking (Hub/Spoke VNet & Subnets), hardened Key Vault integration, dynamic `for_each` mapping, Terraform 1.5+ native HCL checks, and TFLint static analysis governance.

## Repository Architecture
```text
corp-azure-vmss-platform-solution/
├── .gitignore
├── .tflint.hcl                     # Enterprise TFLint Azure ruleset
├── README.md                       # Architecture & operational runbook
├── environments/                   # Parent Multi-Environment Orchestrations
│   ├── dev/
│   │   ├── checks.tf               # Terraform 1.5+ assert & check blocks
│   │   ├── data.tf                 # Data sources for subscription & client config
│   │   ├── main.tf                 # Module orchestration using for_each & map
│   │   ├── outputs.tf              # Structured outputs
│   │   ├── provider.tf             # AzureRM provider configuration
│   │   ├── terraform.tfvars        # Dev configuration parameters
│   │   └── variables.tf            # Typed map(object({...})) variable contracts
│   └── prod/
│       ├── checks.tf               # Production HA & compliance validations
│       ├── data.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── provider.tf
│       ├── terraform.tfvars        # Production HA parameters (4x VMSS, Premium KV)
│       └── variables.tf
└── modules/                        # Reusable Child Modules
    ├── azurerm_key_vault/
    ├── azurerm_linux_virtual_machine_scale_set/
    ├── azurerm_resource_group/
    └── azurerm_virtual_network/
```

## Key Constructs & Practices
- **Child & Parent Hierarchy**: All resources are instantiated via reusable child modules inside `modules/`, orchestrated by parent environments in `environments/`.
- **Pure HCL Guardrails**: Guardrails implemented via native `check` / `assert` blocks and `.tflint.hcl` without external scripts.
- **Dynamic Iterations**: Built exclusively with `for_each` over `map(object({...}))`.
- **Zero-Trust Security**: Key Vault configured with soft-delete retention, purge protection, and RBAC authorization.

