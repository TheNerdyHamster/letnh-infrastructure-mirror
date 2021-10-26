data "hcloud_image" "rocky-8-base" {
  with_selector = "type=base"
  most_recent   = true
  with_status   = ["available"]
}

data "hcloud_ssh_key" "root_ssh_key" {
  name = "tnh-work"
}
