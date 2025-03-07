variable "firewall_aliases" {
  description = "List of firewall aliases"
  type = map(object({
    cidr    = string
    comment = string
  }))
}
