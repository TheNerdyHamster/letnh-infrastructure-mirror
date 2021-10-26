output "servers" {
  value = [for x in hcloud_server.server : x.name]
}
