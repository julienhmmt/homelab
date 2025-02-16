variable "node_name" {
  description = "Proxmox node name"
  type        = string
  default     = "miniquarium"
}

variable "vm_tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = ["NE_PAS_SUPPRIMER"]
}

variable "vm_cpu_cores_number" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "vm_cpu_type" {
  description = "Type of CPU"
  type        = string
  default     = "x86-64-V2-AES"
}

variable "vm_datastore_id" {
  description = "Datastore ID for the VM"
  type        = string
  default     = "local-nvme"
}

variable "vm_description" {
  description = "Description of the VM"
  type        = string
  default     = "NE PAS DEMARRER. Machine utilisée pour créer un disque de données, attaché dans une autre VM."
}

variable "vm_disk_size" {
  description = "Size of the VM disk in GB"
  type        = number
  default     = 16
}

variable "vm_id" {
  description = "Unique ID for the VM"
  type        = number
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}
