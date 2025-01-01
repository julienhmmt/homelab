variable "talos_cluster_details" {
  description = "The Talos cluster details"
  type = object({
    name    = string
    version = string
  })
}