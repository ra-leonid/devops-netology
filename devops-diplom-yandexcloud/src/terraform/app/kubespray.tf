resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 100"
  }

  depends_on = [
    local_file.kuberspray_inventory
  ]
}

resource "null_resource" "kubespray" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./inventory/mycluster/hosts.yaml --become --become-user=root --extra-vars \"{ \\\"supplementary_addresses_in_ssl_keys\\\":${jsonencode(module.all_nodes["control_plane"].external_ip_address_instance)}}\" cluster.yml"
    working_dir = "../kubespray"
  }

  depends_on = [
    null_resource.wait
  ]
}
