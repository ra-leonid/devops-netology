variable image { default =  "centos-8" }
variable name { default = ""}
variable description { default =  "instance from terraform" }
variable users { default = "centos"}
variable cores { default = ""}
variable memory { default = ""}
variable core_fraction { default = "20"}
variable subnet_id { default = ""}
variable nat { default = "false"}
variable instance_count { default = 1 }
variable count_offset { default = 0 } #start numbering from X+1 (e.g. name-1 if '0', name-3 if '2', etc.)
variable count_format { default = "%01d" } #server number format (-1, -2, etc.)
variable boot_disk { default =  "network-hdd" }
variable disk_size { default =  "20" }
variable zone { default =  "" }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }
}

data "yandex_compute_image" "image" {
  family = var.image
}

resource "yandex_compute_instance" "instance" {
  count = var.instance_count
  name = "${var.name}-${format(var.count_format, var.count_offset+count.index+1)}"
  hostname = "${var.name}-${format(var.count_format, var.count_offset+count.index+1)}"
  description = var.description
  zone = var.zone

  resources {
    cores  = var.cores
    memory = var.memory
    core_fraction = var.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
      type = var.boot_disk
      size = var.disk_size
    }
  }
  network_interface {
    subnet_id = var.subnet_id
    nat       = var.nat
  }

  metadata = {
    ssh-keys = "${var.users}:${file("~/.ssh/id_rsa.pub")}"
  }
}


output "internal_ip_address_instance" {
  value = join("; ", yandex_compute_instance.instance.*.network_interface.0.ip_address)
}

output "external_ip_address_instance" {
  //value = join("; ", yandex_compute_instance.instance.*.network_interface.0.nat_ip_address)
  //value = { for k, v in yandex_compute_instance.instance : k => v.network_interface.0.nat_ip_address }
  value = yandex_compute_instance.instance.*.network_interface.0.nat_ip_address
}

output "service_account_id_instance" {
  value = join("; ", yandex_compute_instance.instance.*.service_account_id)
}
