resource "yandex_vpc_network" "netology" {
  name = "network-netology"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.netology.id}"
}

resource "yandex_vpc_subnet" "private" {
  name           = "private"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.netology.id}"
  route_table_id = "${yandex_vpc_route_table.netology-rt.id}"
}

resource "yandex_vpc_route_table" "netology-rt" {
  name           = "nat-instance-route"
  network_id = "${yandex_vpc_network.netology.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${yandex_compute_instance.bastion.network_interface[0].ip_address}"
  }
}