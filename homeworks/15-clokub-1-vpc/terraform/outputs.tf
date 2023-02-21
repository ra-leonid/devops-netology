output "bastion" {
  value       = "${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"
  description = "bastion"
}

output "private_vm" {
  value       = "${yandex_compute_instance.private_vm.network_interface.0.ip_address}"
  description = "private vm"
}

output "ssh_connect_to_bastion" {
  value       = "ssh ${var.tf_user}@${yandex_compute_instance.bastion.network_interface.0.nat_ip_address}"
  description = "ssh connect to bastion"
}

output "ssh_connect_to_private_vm" {
  value       = "ssh ${var.tf_user}@${yandex_compute_instance.private_vm.network_interface.0.ip_address}"
  description = "ssh connect to private_vm"
}
