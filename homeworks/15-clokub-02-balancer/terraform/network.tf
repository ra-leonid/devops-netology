resource "yandex_vpc_network" "netology" {
  name = "network-netology"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.netology.id}"
  depends_on = [
    yandex_vpc_network.netology
  ]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.netology.id}"
  route_table_id = "${yandex_vpc_route_table.netology-rt.id}"
  depends_on = [
    yandex_vpc_network.netology
  ]
}