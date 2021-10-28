resource "hetznerdns_zone" "dns_zone" {
  name = var.dns_zone
  ttl  = 86400
}

resource "hetznerdns_record" "txt" {
  for_each = { for txt in local.dns_records_txt : txt.value => txt }

  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.name
  value   = each.value.value
  type    = "TXT"
}

resource "hetznerdns_record" "ns" {
  for_each = { for ns in local.dns_records_ns : ns => ns }

  zone_id = hetznerdns_zone.dns_zone.id
  name    = "@"
  value   = each.key
  type    = "NS"
}

resource "hetznerdns_record" "caa" {
  zone_id = hetznerdns_zone.dns_zone.id
  name    = "@"
  value   = local.dns_records_caa
  type    = "CAA"
}

resource "hetznerdns_record" "mx" {
  for_each = { for mx in local.dns_records_mx : mx.value => mx }
  zone_id = hetznerdns_zone.dns_zone.id
  name    = each.value.name
  value   = each.value.value
  type    = "MX"
}

