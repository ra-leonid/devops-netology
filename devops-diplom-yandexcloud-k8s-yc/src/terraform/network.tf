resource "yandex_vpc_network" "network-diplom" {
  name = "network-diplom"
  folder_id = var.yc_folder_id
}

resource "yandex_vpc_subnet" "subnet-public-a" {
  name           = "subnet-public-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = ["192.168.10.0/24"]

}

resource "yandex_vpc_subnet" "subnet-public-b" {
  name           = "subnet-public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = ["192.168.11.0/24"]

}

resource "yandex_vpc_subnet" "subnet-public-c" {
  name           = "subnet-public-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.network-diplom.id
  v4_cidr_blocks = ["192.168.12.0/24"]

}
