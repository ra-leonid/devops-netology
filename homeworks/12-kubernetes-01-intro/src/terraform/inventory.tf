resource "local_file" "inventory" {
  content = <<-DOC
---
minikube:
  hosts:
    minikube1:
     ansible_host: ${yandex_compute_instance.minikube.network_interface.0.nat_ip_address}
     ansible_user: ${var.tf_user}
    DOC
  filename = "../ansible/inventory.yml"

  depends_on = [
    yandex_compute_instance.minikube
  ]
}
