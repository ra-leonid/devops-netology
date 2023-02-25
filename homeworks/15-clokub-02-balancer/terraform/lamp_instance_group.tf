resource "yandex_iam_service_account" "ig-sa" {
  name        = "ig-sa"
  description = "service account to manage IG"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  members   = [
    "serviceAccount:${yandex_iam_service_account.ig-sa.id}",
  ]
  depends_on = [
    yandex_iam_service_account.ig-sa
  ]

}

data "yandex_compute_image" "lamp" {
  family = "lamp"
}

// Группа ВМ фиксированного размера с сетевым балансировщиком
resource "yandex_compute_instance_group" "site-devops-ig" {
  name               = "fixed-ig-with-balancer"
  folder_id          = var.yc_folder_id
  service_account_id = "${yandex_iam_service_account.ig-sa.id}"
  //deletion_protection = true
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = data.yandex_compute_image.lamp.id
        size     = 4
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.netology.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }

    network_settings {
      type = "STANDARD"
    }

    metadata = {
      ssh-keys = "${var.tf_user}:${file("~/.ssh/id_rsa.pub")}"
      user-data = file("${path.module}/data/cloud-config.yml")
  }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = [var.yc_region]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
/*
  load_balancer {
    target_group_name        = "ig-1"
    target_group_description = "load balancer target group"
  }
*/
  depends_on = [
    yandex_vpc_subnet.public,
    yandex_resourcemanager_folder_iam_binding.editor
  ]
}
