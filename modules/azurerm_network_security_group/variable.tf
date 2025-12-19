# Network Security Group (NSG)
variable "nsgs" {
  description = "Map of Network Security Group configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    tags                = optional(map(string))

    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range           = optional(string)
      destination_port_range      = optional(string)
      source_address_prefix       = optional(string)
      destination_address_prefix  = optional(string)
      source_port_ranges          = optional(list(string))
      destination_port_ranges     = optional(list(string))
      source_address_prefixes     = optional(list(string))
      destination_address_prefixes = optional(list(string))
    })), [])
  }))
}