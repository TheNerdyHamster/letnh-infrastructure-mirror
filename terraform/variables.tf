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

locals {
  servers = {
    "letnh.com" = {
      server_type = "cpx11"
      internal_ip = "10.0.0.2"
    }
    "data.letnh.com" = {
      server_type = "cpx11"
      internal_ip = "10.0.0.3"
    }
    "monitoring.letnh.com" = {
      server_type = "cpx11"
      internal_ip = "10.0.0.4"
    }
  }

  volumes = [
    {
      server = "letnh.com"
      size   = 10
    }
  ]
}

# DNS Variable & Locals
variable "dns_zone" {
  type        = string
  description = "Hetzner DNS zone"
  default     = "letnh.xyz"
}

locals {
  dns_records_ns = [
    "hydrogen.ns.hetzner.com.",
    "oxygen.ns.hetzner.com.",
    "helium.ns.hetzner.de."
  ]

  dns_records_txt = [
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=none"
    },
    {
      name  = "@"
      value = "v=spf1 include:_spf.protonmail.ch mx ~all"
    },
    {
      name  = "@"
      value = "protonmail-verification=878b291be27fab4e9303fcd939dac61bc95c740c"
    }
  ]
}
