# Network Interface (NIC)

variable "nics" {
  description = "Map of Network Interface configurations"
  type = map(object({
     # data block variable
    vnet_name         = string
    subnet_name       = string
    pip_name          = string
    # resource block variable
    name                = string
    resource_group_name = string
    location            = string
    ip_forwarding_enabled         = optional(bool)
    accelerated_networking_enabled = optional(bool)
    tags                          = optional(map(string))

    ip_configurations = optional(list(object({
      name                          = string
      # subnet_id                     = string # if we using data block for this then not required here
      private_ip_address_allocation = string
      private_ip_address_version    = optional(string)
      public_ip_address_id          = optional(string)
      primary                       = optional(bool)
    })), [])
  }))
}