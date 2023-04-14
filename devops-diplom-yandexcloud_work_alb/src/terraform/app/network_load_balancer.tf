#resource "yandex_lb_target_group" "site-devops-lb-tg" {
#  name = "${terraform.workspace}-k8s-lb-target-group"
#  region_id = "ru-central1"
#
#  dynamic "target" {
#    for_each = [for s in yandex_compute_instance.node : {
#      address   = s.network_interface.0.ip_address
#      subnet_id = s.network_interface.0.subnet_id
#    }]
#    content {
#      subnet_id  = target.value["subnet_id"]
#      address = target.value["address"]
#    }
#  }
#  depends_on = [
#    yandex_compute_instance.node
#  ]
#}
#
#resource "yandex_lb_network_load_balancer" "site-devops-lb" {
#  name = "site-devops-load-balancer"
#  listener {
#    name = "my-listener"
#    port = 80
#    target_port = 30001
#    external_address_spec {
#          address = yandex_vpc_address.addr-web.external_ipv4_address[0].address
#    }
#  }
#  attached_target_group {
#    target_group_id = yandex_lb_target_group.site-devops-lb-tg.id
#    healthcheck {
#      name = "http"
#      interval            = 10 // Интервал ожидания между проверками работоспособности в секундах.
#      timeout             = 5  // Время ожидания ответа до истечения времени проверки работоспособности в секундах.
#      unhealthy_threshold = 3  // Количество неудачных проверок работоспособности, прежде чем управляемый экземпляр будет объявлен неработоспособным.
#      http_options {
#        port = 30001
#        path = "/login"
#      }
#    }
#  }
#}
