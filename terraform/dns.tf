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
  for_each = { for record in var.server_records : record.domain => record }

  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.domain
  value   = hcloud_server.server[each.value.server].ipv4_address
  ttl     = 1800
  type    = "A"
}

resource "hetznerdns_record" "server_aaaa_records" {
  for_each = { for record in var.server_records : record.domain => record }

  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.domain
  value   = hcloud_server.server[each.value.server].ipv6_address
  ttl     = 1800
  type    = "AAAA"
}
