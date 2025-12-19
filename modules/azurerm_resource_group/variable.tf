variable "rgs" {
type = map(object({
        name     = string                   #name of the resource group
        location = string                   #location of the resource group
        managed_by = optional(string)       #who is managing the resource group
        tags     = optional(map(string))    #tag for specifying the project,owner,cost etc
    }))
}
