variable "hcloud_token" {
  type    = string
  sensitive = true
}

source "hcloud" "rocky-8-base" {
  token        = "${var.hcloud_token}"
  communicator = "ssh"
  image_filter {
    with_selector = ["dist==rocky"]
    most_recent   = true
  }
  location                = "nbg1"
  pause_before_connecting = "10s"
  server_name             = "rocky-8-base"
  server_type             = "cx11"
  snapshot_labels = {
    dist   = "rocky"
    type   = "base"
  }
  snapshot_name  = "rocky-8-base"
  ssh_keys       = ["tnh-work"]
  ssh_username   = "root"
}

build {
  sources = ["source.hcloud.rocky-8-base"]

  provisioner "ansible" {
    playbook_file = "../provisioning/playbooks/basic.yml"
    roles_path    = "../provisioning/roles"
    use_proxy     = false
  }
}
