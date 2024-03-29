resource "local_file" "kuberspray_inventory" {
  content = templatefile("templates/hosts.tpl",
    {
      all_k8s_nodes = flatten([module.all_nodes["control_plane"].internal_ip_address_instance, module.all_nodes["node"].internal_ip_address_instance])
      control_plane_nodes = module.all_nodes["control_plane"].internal_ip_address_instance
      slave_nodes = module.all_nodes["node"].internal_ip_address_instance

      tf_user = var.tf_user
      ip_bastion = module.vpc.nat_ip_address
    }
  )
  filename = "../../vendor/kubespray/inventory/mycluster/hosts.yaml"

  depends_on = [
    module.all_nodes
  ]
}
#
#resource "null_resource" "wait" {
#  provisioner "local-exec" {
#    command = "sleep 100"
#  }
#
#  depends_on = [
#    local_file.kuberspray_inventory
#  ]
#}
#
#resource "null_resource" "kubespray" {
#  provisioner "local-exec" {
#    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ./inventory/mycluster/hosts.yaml --become --become-user=root --extra-vars \"{ \\\"supplementary_addresses_in_ssl_keys\\\":${jsonencode(module.all_nodes["control_plane"].external_ip_address_instance)}}\" cluster.yml"
#    working_dir = "../../vendor/kubespray"
#  }
#
#  depends_on = [
#    null_resource.wait
#  ]
#}