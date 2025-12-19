variable "vnets" {
  description = "Map of Virtual Network configurations"
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_space       = list(string)
    dns_servers         = optional(list(string))
    bgp_community           = optional(string)
    edge_zone               = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                = optional(map(string))

    ddos_protection_plan = optional(list(object({
      id     = string
      enable = bool
    })), [])

    subnets = optional(list(object({
      name                                      = string
      address_prefix                            = list(string)
      service_endpoints                         = optional(list(string))
      private_endpoint_network_policies         = optional(bool)
      private_link_service_network_policies_enabled = optional(bool)
      delegation = optional(list(object({
        name = string
        service_delegation = object({
          name    = string
          actions = list(string)
        })
      })), [])
    })), [])
  }))
}
