resource "hetznerdns_zone" "dns_zone" {
  name = var.dns_zone
  ttl  = 86400
}

resource "hetznerdns_record" "records" {
  for_each = { for record in var.dns_records : record.value => record }

  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.name
  value   = each.value.value
  ttl     = each.value.ttl
  type    = each.value.type
}

resource "hetznerdns_record" "server_a_records" {
  for_each = var.servers

  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.domain
  value   = hcloud_server.server[each.key].ipv4_address
  type    = "A"
}

resource "hetznerdns_record" "server_aaaa_records" {
  for_each = var.servers

  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.domain
  value   = hcloud_server.server[each.key].ipv6_address
  type    = "AAAA"
}
