resource "yandex_vpc_route_table" "netology-rt" {
  name           = "nat-instance-route"
  network_id = "${yandex_vpc_network.netology.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${yandex_compute_instance.bastion.network_interface.0.ip_address}"
  }
  depends_on = [
    yandex_vpc_network.netology,
    yandex_compute_instance.bastion
  ]
}

data "yandex_compute_image" "nat-instance-image" {
  family = "nat-instance-ubuntu"
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  platform_id = "standard-v1"
  zone        = "${var.yc_region}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.nat-instance-image.id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "${var.tf_user}:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [
    yandex_vpc_subnet.public
  ]
}
