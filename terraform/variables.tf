# Provider variabels
variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "hetzner_dns_token" {
  type      = string
  sensitive = true
}

# Hetzner Variables & Locals
variable "network_range" {
  type        = string
  description = "Private network range"
  default     = "10.0.0.0/16"
}

variable "network_subnet_range" {
  type        = string
  description = "Subnet range within network"
  default     = "10.0.0.0/24"
}

variable "volume_format" {
  type        = string
  description = "Volume drive format either XFS or EXT4"
  default     = "xfs"
}

variable "servers" {
  type = map(object({
    type        = string
    internal_ip = string
#    domain      = string
  }))
}

variable "server_records" {
  type = list(object({
    server = string
    domain = string
  }))
}

variable "volumes" {
  type = map(object({
    size = number
  }))
}

# DNS Variable & Locals
variable "dns_zone" {
  type        = string
  description = "Hetzner DNS zone"
  default     = "letnh.xyz"
}

variable "dns_records" {
  type = list(object({
    name  = string
    value = string
    ttl   = string
    type  = string
  }))
}
