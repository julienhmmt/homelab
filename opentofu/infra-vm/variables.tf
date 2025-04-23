variable "firewall_aliases" {
  description = "List of firewall aliases"
  type = map(object({
    cidr    = string
    comment = string
  }))
}

variable "firewall_security_groups" {
  description = "List of firewall security groups"
  type = map(object({
    comment = string
    rules = list(object({
      action  = string
      comment = string
      dest    = string
      dport   = string
      enabled = bool
      log     = string
      proto   = string
      source  = string
      type    = string
    }))
  }))
}
