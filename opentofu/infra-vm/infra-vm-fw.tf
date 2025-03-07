# options générales du firewall, au niveau "datacenter"
resource "proxmox_virtual_environment_cluster_firewall" "this" {
  ebtables      = false
  enabled       = true
  input_policy  = "DROP"
  output_policy = "ACCEPT"
  log_ratelimit {
    enabled = false
    burst   = 10
    rate    = "5/second"
  }
}

# alias
resource "proxmox_virtual_environment_firewall_alias" "aliases" {
  for_each = var.firewall_aliases
  name     = each.key
  cidr     = each.value.cidr
  comment  = each.value.comment
}

# groupes de sécurité pour les vm
resource "proxmox_virtual_environment_cluster_firewall_security_group" "security_groups" {
  for_each = var.firewall_security_groups
  name     = each.key
  comment  = each.value.comment

  dynamic "rule" {
    for_each = each.value.rules
    content {
      action  = rule.value.action
      comment = rule.value.comment
      dest    = rule.value.dest
      dport   = rule.value.dport
      enabled = rule.value.enabled
      log     = rule.value.log
      proto   = rule.value.proto
      source  = rule.value.source
      type    = rule.value.type
    }
  }
}
