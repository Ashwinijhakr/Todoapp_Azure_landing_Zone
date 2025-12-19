# NIC ↔ NSG Association
variable "nic_nsg_association" {
  description = "Map defining NIC and NSG association"
  type = map(object({
    # data block variable
    nic_name                = string
    nsg_name                = string
    resource_group_name     = string
    # resource block variable  # if we using data block for this then not required here
    # network_interface_id      = string
    # network_security_group_id = string
  }))
}