variable "public_ips" {
  description = "Map of public IP configurations"
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    allocation_method           = string
    zones                       = optional(list(string))
    sku                         = optional(string)
    idle_timeout_in_minutes     = optional(number)
    ip_tags                     = optional(map(string))
    ddos_protection_mode        = optional(string)
    ddos_protection_plan_id     = optional(string)
    reverse_fqdn                = optional(string)
    domain_name_label           = optional(string)
    public_ip_prefix_id         = optional(string)
    tags                        = optional(map(string))
  }))
}
