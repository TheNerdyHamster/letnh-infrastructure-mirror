variable "hcloud_token" {
  type      = string
  sensitive = true
}

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
      size = 10
    }
  ]
}
