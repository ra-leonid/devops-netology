output "ssh_connect_to_bastion" {
  value       = "ssh ${var.tf_user}@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"
  description = "ssh connect to bastion"
}

output "ssh_connect_to_frontend" {
  value       = "ssh ${var.tf_user}@${yandex_compute_instance.private_vm.network_interface.0.ip_address}"
  description = "ssh connect to frontend"
}

output "url-network-load-balancer" {
  value       = "http://${flatten(yandex_lb_network_load_balancer.site-devops-lb.listener.*.external_address_spec).0.address}"
  description = "network load balancer"
}
output "url-app-load-balancer" {
  value       = "http://${yandex_alb_load_balancer.site-devops-alb.listener.0.endpoint.0.address.0.external_ipv4_address.0.address}"
  description = "application load balancer"
}
