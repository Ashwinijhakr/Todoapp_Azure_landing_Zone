output "pip_ids" {
  value = { for k, v in azurerm_public_ip.pip: k => v.id }
}
output "ip_address" {
  value = { for k, v in azurerm_public_ip.pip: k => v.ip_address }
}