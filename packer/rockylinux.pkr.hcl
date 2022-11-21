variable "hcloud_token" {
  type      = string
  default   = "${env("HCLOUD_TOKEN")}"
  sensitive = true
}

locals {
  isotime = formatdate("YYYY-MM-DD'T'hh:mm", timestamp())
}

source "hcloud" "rocky-9-base" {
  token                   = "${var.hcloud_token}"
  communicator            = "ssh"
  image                   = "rocky-9"
  location                = "nbg1"
  pause_before_connecting = "10s"
  server_name             = "rocky-9-base"
  server_type             = "cx11"
  snapshot_labels = {
    dist = "rocky"
    type = "base"
  }
  snapshot_name = "rocky-9-base-${local.isotime}"
  ssh_keys      = ["tnh-work"]
  ssh_username  = "root"
}

build {
  sources = ["source.hcloud.rocky-9-base"]

  provisioner "ansible" {
    playbook_file = "../provisioning/playbooks/tasks/base_image.yml"
    #inventory_directory = "../provisioning/"
    host_alias = "packer-base-image"
    #roles_path = "../../roles"
    use_proxy = false
  }
}
