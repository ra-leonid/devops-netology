data "yandex_compute_image" "image" {
  family = var.family_id
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
      image_id = "fd8o8aph4t4pdisf1fio"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.public.id}"
    nat = true
  }

  metadata = {
    ssh-keys = "${var.tf_user}:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  platform_id = "standard-v1"
  zone        = "${var.yc_region}"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
    nat = false
  }

  metadata = {
    ssh-keys = "${var.tf_user}:${file("~/.ssh/id_rsa.pub")}"
  }
}