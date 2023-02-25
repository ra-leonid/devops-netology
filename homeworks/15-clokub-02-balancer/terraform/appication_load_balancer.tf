resource "yandex_alb_target_group" "site-devops-alb-tg" {

  dynamic "target" {
    for_each = yandex_compute_instance_group.site-devops-ig.instances
    content {
      subnet_id = "${yandex_vpc_subnet.public.id}"
      ip_address   = "${target.value["network_interface"]["0"]["ip_address"]}"
    }
  }
}

resource "yandex_alb_backend_group" "site-devops-alb-bg" {
  name      = "site-devops-alb-backend-group"
  http_backend {
    name = "site-devops-http-backend"
    weight = 1
    port = 80
    target_group_ids = ["${yandex_alb_target_group.site-devops-alb-tg.id}"]
    /*
    tls {
      sni = "backend-domain.internal"
    }
    */
    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout = "1s"
      interval = "1s"
      http_healthcheck {
        path  = "/"
      }
    }
    //http2 = "true"
  }
}

resource "yandex_alb_http_router" "site-devops-alb-http-router" {
  name      = "site-devops-alb-http-router"
}

resource "yandex_alb_virtual_host" "site-devops-virtual-host" {
  name           = "site-devops-virtual-host"
  http_router_id = yandex_alb_http_router.site-devops-alb-http-router.id
  route {
    name = "site-devops-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.site-devops-alb-bg.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "site-devops-alb" {
  name        = "site-devops-alb"
  network_id  = yandex_vpc_network.netology.id

  allocation_policy {
    location {
      zone_id   = var.yc_region
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "site-devops-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.site-devops-alb-http-router.id
      }
    }
  }
/*
  log_options {
    discard_rule {
      http_code_intervals = ["2XX"]
      discard_percent = 75
    }
  }
  */
}