terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.31.0"
    }
    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "~> 1.1.1"
    }
  }
  required_version = "~> 1.0.0"
}
