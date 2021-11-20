resource "hcloud_network" "network" {
  name     = "network"
  ip_range = var.network_range
}

resource "hcloud_network_subnet" "network_subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.network_subnet_range
}

resource "hcloud_server" "server" {
  for_each = var.servers

  name        = each.key
  image       = data.hcloud_image.rocky-8-base.id
  server_type = each.value.type
  ssh_keys    = [data.hcloud_ssh_key.root_ssh_key.id]

  network {
    network_id = hcloud_network.network.id
    ip         = each.value.internal_ip
  }
  lifecycle {
    ignore_changes = [image]
  }
  depends_on = [
    hcloud_network_subnet.network_subnet
  ]
}

resource "hcloud_volume" "volume" {
  for_each = var.volumes

  name      = "${each.key}-volume"
  server_id = hcloud_server.server[each.key].id
  size      = each.value.size
  format    = var.volume_format
}

resource "hcloud_rdns" "rdns4" {
  for_each = var.servers

  server_id  = hcloud_server.server[each.key].id
  ip_address = hcloud_server.server[each.key].ipv4_address
  dns_ptr    = each.key
}

resource "hcloud_rdns" "rdns6" {
  for_each = var.servers

  server_id  = hcloud_server.server[each.key].id
  ip_address = hcloud_server.server[each.key].ipv6_address
  dns_ptr    = each.key
}
