data "yandex_compute_image" "default-image" {
  family = var.family_id
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
      image_id = data.yandex_compute_image.default-image.id
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.private.id}"
    nat = false
  }

  metadata = {
    ssh-keys = "${var.tf_user}:${file("~/.ssh/id_rsa.pub")}"
  }

  depends_on = [
    yandex_vpc_subnet.private
  ]
}