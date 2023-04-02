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

resource "yandex_lb_target_group" "site-devops-lb-tg" {
  name      = "netology-tg"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = yandex_compute_instance_group.site-devops-ig.instances
    content {
      subnet_id = "${yandex_vpc_subnet.public.id}"
      address   = "${target.value["network_interface"]["0"]["ip_address"]}"
    }
  }
}

resource "yandex_lb_network_load_balancer" "site-devops-lb" {
  name = "site-devops-load-balancer"
  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.site-devops-lb-tg.id
    healthcheck {
      name = "http"
      interval            = 10 // Интервал ожидания между проверками работоспособности в секундах.
      timeout             = 5  // Время ожидания ответа до истечения времени проверки работоспособности в секундах.
      unhealthy_threshold = 3  // Количество неудачных проверок работоспособности, прежде чем управляемый экземпляр будет объявлен неработоспособным.
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
