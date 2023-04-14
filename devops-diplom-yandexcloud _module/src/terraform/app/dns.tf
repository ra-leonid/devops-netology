resource "yandex_dns_zone" "app_url" {
  name        = "app-url"
#
#  labels = {
#    label1 = "label-1-value"
#  }

  zone             = "${var.url}."
  public           = true
}

resource "yandex_dns_recordset" "rs-web" {
  zone_id = yandex_dns_zone.app_url.id
  name    = "meow-app.duckdns.org."
  type    = "A"
  ttl     = 200
  data    = ["${yandex_vpc_address.addr-web.external_ipv4_address[0].address}"]

  depends_on = [
    yandex_alb_load_balancer.k8s-alb-balancer,
    yandex_dns_zone.app_url
  ]
}
