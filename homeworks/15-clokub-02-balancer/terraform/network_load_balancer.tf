
resource "yandex_lb_target_group" "site-devops-lb-tg" {
  name      = "netology-tg"
  region_id = "ru-central1"

#  dynamic "target" {
#    for_each = yandex_compute_instance_group.site-devops-ig.instances
#    content {
#      subnet_id = "${yandex_vpc_subnet.private.id}"
#      address   = "${target.value["network_interface"]["0"]["ip_address"]}"
#    }
#  }
  dynamic "target" {
    for_each = [for s in yandex_compute_instance_group.site-devops-ig.instances : {
      address   = s.network_interface.0.ip_address
      subnet_id = s.network_interface.0.subnet_id
    }]
    content {
      subnet_id  = target.value.subnet_id
      address = target.value.address
    }
  }
  depends_on = [
    yandex_compute_instance_group.site-devops-ig
  ]

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
