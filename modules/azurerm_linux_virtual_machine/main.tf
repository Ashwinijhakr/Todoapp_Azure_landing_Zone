# Linux Virtual Machine (VM)
resource "azurerm_linux_virtual_machine" "vm" {

  for_each = var.vms

  # ---------- Required Arguments ----------
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  size                = each.value.size
  # ---------- Credentials from Key Vault ----------
  admin_username                  = data.azurerm_key_vault_secret.vm_admin_username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.vm_admin_password[each.key].value
  disable_password_authentication = each.value.disable_password_authentication

  network_interface_ids = [data.azurerm_network_interface.nic_ids[each.key].id]
  # ---------- Required Nested Block ----------
  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  # ---------- Optional Arguments ----------
  computer_name              = each.value.computer_name
  custom_data                = base64encode(file(each.value.script_name))   # custom_data usage
  provision_vm_agent         = each.value.provision_vm_agent
  allow_extension_operations = each.value.allow_extension_operations
  edge_zone                  = each.value.edge_zone
  encryption_at_host_enabled = each.value.encryption_at_host_enabled
  patch_mode                 = each.value.patch_mode
  reboot_setting             = each.value.reboot_setting
  secure_boot_enabled        = each.value.secure_boot_enabled
  vtpm_enabled               = each.value.vtpm_enabled
  tags                       = each.value.tags
  zone                       = each.value.zone

  # ---------- Optional Nested Block ----------
  dynamic "os_disk" {
    for_each = each.value.os_disk
    content {
      name                 = os_disk.value.name
      caching              = os_disk.value.caching
      storage_account_type = os_disk.value.storage_account_type
      disk_size_gb         = os_disk.value.disk_size_gb
    }
  }

  # ---------- Optional Nested Block ----------
  dynamic "admin_ssh_key" {
    for_each = each.value.admin_ssh_key
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  # ---------- Optional Nested Block ----------
  dynamic "boot_diagnostics" {
    for_each = each.value.boot_diagnostics
    content {
      storage_account_uri = boot_diagnostics.value.storage_account_uri
    }
  }
}
