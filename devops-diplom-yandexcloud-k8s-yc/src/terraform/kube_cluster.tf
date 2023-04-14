resource "yandex_kubernetes_cluster" "cluster-kube" {
  name        = "cluster-kube"
  description = "Кластер для диплома"

  network_id = yandex_vpc_network.network-diplom.id

  cluster_ipv4_range = "10.10.0.0/16"
  service_ipv4_range = "10.20.0.0/16"

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.subnet-public-a.zone
        subnet_id = yandex_vpc_subnet.subnet-public-a.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-public-b.zone
        subnet_id = yandex_vpc_subnet.subnet-public-b.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-public-c.zone
        subnet_id = yandex_vpc_subnet.subnet-public-c.id
      }
    }

    version   = var.k8s_version
    public_ip = true


    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }

      maintenance_window {
        day        = "friday"
        start_time = "10:00"
        duration   = "4h30m"
      }
    }
  }

  #kms_provider {
   # key_id = yandex_kms_symmetric_key.kms-bucket.id
  #}

  service_account_id      = yandex_iam_service_account.kube-admin.id
  node_service_account_id = yandex_iam_service_account.kube-admin.id

  release_channel = "STABLE"

  network_policy_provider = "CALICO"

  depends_on              = [
    yandex_resourcemanager_folder_iam_binding.editor_netology-kube,
    yandex_resourcemanager_folder_iam_binding.images-puller,
    yandex_resourcemanager_folder_iam_binding.load-balancer-admin,
    yandex_iam_service_account.kube-admin
  ]

}

resource "yandex_kubernetes_node_group" "node-diplom" {
  cluster_id = yandex_kubernetes_cluster.cluster-kube.id
  name       = "node-diplom"

  version = var.k8s_version


  instance_template {
    platform_id = "standard-v1"

    network_interface {
      nat        = true
      subnet_ids = [
        "${yandex_vpc_subnet.subnet-public-a.id}", "${yandex_vpc_subnet.subnet-public-b.id}", "${yandex_vpc_subnet.subnet-public-c.id}"
      ]
    }

    metadata = {
      ssh-keys = "${var.tf_user}:${file(var.ssh-keys)}"
    }

    resources {
      memory = 2
      cores  = 2
      core_fraction = 20
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "docker"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = "${yandex_vpc_subnet.subnet-public-a.zone}"
    }
    location {
      zone = "${yandex_vpc_subnet.subnet-public-b.zone}"
    }
	location {
      zone = "${yandex_vpc_subnet.subnet-public-c.zone}"
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
