resource "hetznerdns_zone" "dns_zone" {
  name = var.dns_zone
  ttl  = 86400
}

resource "hetznerdns_record" "txt" {
  for_each = { for txt in local.dns_records_txt : txt.value => txt }

  zone_id  = hetznerdns_zone.dns_zone.id
  name     = each.value.name
  value    = each.value.value
  type     = "TXT"
}
