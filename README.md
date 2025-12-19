# 🌐 Azure Infrastructure Deployment using Terraform (Generic & Modular)

This repository contains a **fully modular and reusable Terraform setup** to deploy a complete Azure environment.
The project provisions **Resource Groups, Virtual Networks, Subnets, NSGs, NICs, Public IPs, Storage Accounts, Key Vaults, and Virtual Machines (Linux/Windows)** — all dynamically using maps and environment-based configurations.

---

## 🚀 Features

* **Modular design** – each Azure resource (RG, VNet, Subnet, NSG, NIC, PIP, Key Vault, VM, etc.) is managed in its own Terraform module
* **Dynamic mapping with `for_each`** – enables creation of multiple resources from a single `.tfvars` file
* **Data source integration** – dynamically fetches resource IDs (Subnet, NSG, NIC, etc.)
* **Optional and dynamic blocks** – uses `try()` and `dynamic` blocks for flexibility
* **Environment-based configuration** – supports multiple environments (`dev`, `qa`, `prod`)
* **Dependency-safe execution** – automatic ordering between modules (via data lookups and `depends_on`)
* **Supports secure secret management** – through Azure Key Vault and Key Vault Secrets

---

## 🏗️ Project Structure

```
📦 Azure_Resource_code_For_each_Tfvars/
│
├── modules/
│   ├── azurerm_resource_group/
│   ├── azurerm_virtual_network/
│   ├── azurerm_subnet/
│   ├── azurerm_network_security_group/
│   ├── azurerm_public_ip/
│   ├── azurerm_network_interface/
│   ├── azurerm_nic_nsg_association/
│   ├── azurerm_storage_account/
│   ├── azurerm_key_vault/
│   ├── azurerm_key_vault_secret/
│   └── azurerm_linux_virtual_machine/
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       └── ...
│
└── README.md
```

---

## ⚙️ Prerequisites

Before you begin, ensure you have:

* **Terraform** v1.6 or higher
* **Azure CLI** installed and authenticated

  ```bash
  az login
  az account set --subscription "<your-subscription-id>"
  ```
* **Permissions**: Owner/Contributor access to create Azure resources

---

## 🧩 Modules Overview

| Module                           | Description                                                                      |
| -------------------------------- | -------------------------------------------------------------------------------- |
| `azurerm_resource_group`         | Creates Azure Resource Groups                                                    |
| `azurerm_virtual_network`        | Creates Virtual Networks (VNet)                                                  |
| `azurerm_subnet`                 | Creates Subnets under VNets                                                      |
| `azurerm_network_security_group` | Creates Network Security Groups                                                  |
| `azurerm_public_ip`              | Creates static or dynamic Public IP addresses                                    |
| `azurerm_network_interface`      | Creates NICs with dynamic Subnet & Public IP association                         |
| `azurerm_nic_nsg_association`    | Associates NICs with NSGs                                                        |
| `azurerm_storage_account`        | Creates Storage Accounts for diagnostics and data storage                        |
| `azurerm_key_vault`              | Creates Azure Key Vault for secure secret management                             |
| `azurerm_key_vault_secret`       | Creates and stores sensitive secrets (like passwords, SSH keys) inside Key Vault |
| `azurerm_linux_virtual_machine`  | Deploys Linux VMs with dynamic NIC and diagnostic configuration                  |

---

## 🔑 Key Vault Module Details

**`azurerm_key_vault`**
This module creates a secure **Azure Key Vault** for storing credentials, SSH keys, and sensitive application secrets.

Example:

```hcl
keyvault-main = {
  kv1 = {
    name                = "kv-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
    sku_name            = "standard"
    tenant_id           = "your-tenant-id"
    soft_delete_enabled = true
    purge_protection_enabled = false
    tags = { environment = "dev" }
  }
}
```

---

## 🔐 Key Vault Secret Module Details

**`azurerm_key_vault_secret`**
This module securely stores values inside the Key Vault created above.

Example:

```hcl
keyvaultsecret-main = {
  secret1 = {
    name         = "adminPassword"
    value        = "P@ssword123!"
    key_vault_id = "/subscriptions/<sub_id>/resourceGroups/rg-dev/providers/Microsoft.KeyVault/vaults/kv-dev"
    tags         = { environment = "dev" }
  }
}
```

---

## 🌍 Public IP Module Details

**`azurerm_public_ip`**
This module creates Public IPs used by NICs and VMs.

Example:

```hcl
pip-main = {
  pip1 = {
    name                = "pip-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
    allocation_method   = "Dynamic"
    sku                 = "Basic"
    tags                = { environment = "dev" }
  }
}
```

---

## 📄 Example: `terraform.tfvars` (Dev Environment)

```hcl
vnet-main = {
  vnet1 = {
    name                = "vnet-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
    address_space       = ["10.0.0.0/16"]
    tags = {
      environment = "dev"
      project     = "project-x"
    }
  }
}

subnet-main = {
  subnet1 = {
    name                 = "subnet-dev1"
    resource_group_name  = "rg-dev"
    vnet_name            = "vnet-dev"
    address_prefixes     = ["10.0.0.0/24"]
  }
}

nsg-main = {
  nsg1 = {
    name                = "nsg-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
  }
}

pip-main = {
  pip1 = {
    name                = "pip-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
    allocation_method   = "Dynamic"
    sku                 = "Basic"
    tags = { environment = "dev" }
  }
}

keyvault-main = {
  kv1 = {
    name                = "kv-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
    sku_name            = "standard"
    tenant_id           = "xxxx-xxxx-xxxx"
    soft_delete_enabled = true
    purge_protection_enabled = false
    tags = { environment = "dev" }
  }
}

keyvaultsecret-main = {
  secret1 = {
    name         = "adminPassword"
    value        = "P@ssword123!"
    key_vault_id = "/subscriptions/<sub_id>/resourceGroups/rg-dev/providers/Microsoft.KeyVault/vaults/kv-dev"
    tags         = { environment = "dev" }
  }
}

nic-main = {
  nic1 = {
    name                = "nic-dev"
    location            = "East US"
    resource_group_name = "rg-dev"
    vnet_name           = "vnet-dev"
    subnet_name         = "subnet-dev1"
    pip_name            = "pip-dev"
    enable_ip_forwarding          = false
    enable_accelerated_networking = false
    tags = { environment = "dev" }

    ip_configurations = [
      {
        name                          = "ipconfig1"
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version    = "IPv4"
        primary                       = true
      }
    ]
  }
}

vms-main = {
  vm1 = {
    name                            = "vm-dev"
    location                        = "East US"
    resource_group_name             = "rg-dev"
    size                            = "Standard_B2s"
    admin_username                  = "azureuser"
    admin_password                  = "P@ssword123!"
    disable_password_authentication = false
    provision_vm_agent              = true
    nic_name                        = "nic-dev"
    source_image_reference = {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS"
      version   = "latest"
    }
    os_disk = [{
      name                 = "vm-dev-osdisk"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 30
    }]
    admin_ssh_key    = []
    boot_diagnostics = []
    tags             = { environment = "dev" }
  }
}
```

---

## 🚀 Deployment Steps

### 1️⃣ Initialize Terraform

```bash
terraform init
```

### 2️⃣ Validate Configuration

```bash
terraform validate
```

### 3️⃣ Preview Execution Plan

```bash
terraform plan
```

### 4️⃣ Apply Changes

```bash
terraform apply -auto-approve
```

### 5️⃣ Destroy All Resources

```bash
terraform destroy -auto-approve
```

---

## 🧠 Highlights

* Modular and reusable across multiple environments
* Uses `for_each` and maps for scalable deployments
* Automatically retrieves existing resource IDs (via `data` sources)
* Supports **secure credential management** using Key Vault
* Complete environment segregation (dev, qa, prod)
* Supports full dependency chaining between resources

---

## 🧾 Outputs

Typical outputs include:

* Resource Group Name
* VNet and Subnet IDs
* Public IP and NIC IDs
* Key Vault and Secret URIs
* VM Private/Public IPs

View outputs:

```bash
terraform output
```

---

## 🧰 Troubleshooting

| Issue                                   | Cause                               | Resolution                                       |
| --------------------------------------- | ----------------------------------- | ------------------------------------------------ |
| `subnet_id is required`                 | Subnet not found                    | Ensure `vnet_name` and `subnet_name` are correct |
| `network_interface_ids is required`     | NIC ID missing                      | Add NIC data lookup or dependency                |
| `ResourceNotFound 404`                  | Region mismatch or missing resource | Ensure all modules use same region               |
| `Provider produced inconsistent result` | Azure API delay                     | Re-run `terraform apply` or `refresh`            |
| `The specified resource does not exist` | Storage or Key Vault mismatch       | Match resource group and region                  |

---
#unexpected status 409 (409 Conflict) with error: SkuNotAvailable: The requested VM size for resource 'Following SKUs have failed for Capacity Restrictions-- either change region or either change VM SIZE which support in given region
## 🏁
