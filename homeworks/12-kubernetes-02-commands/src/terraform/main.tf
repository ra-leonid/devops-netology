data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "minikube" {
  name                      = "minikube1"
  zone                      = "ru-central1-a"
  hostname                  = "minikube1"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.image.id
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "${var.tf_user}:${file("~/.ssh/id_rsa.pub")}"
  }
}
