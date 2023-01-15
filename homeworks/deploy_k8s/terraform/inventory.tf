resource "local_file" "kuberspray_inventory" {
  content = templatefile("templates/hosts.tpl",
    {
      all_k8s_nodes = flatten([module.all_nodes["control_plane"].external_ip_address_instance, module.all_nodes["node"].external_ip_address_instance])
      control_plane_nodes = module.all_nodes["control_plane"].external_ip_address_instance
      slave_nodes = module.all_nodes["node"].external_ip_address_instance
      tf_user = var.tf_user
    }
  )
  filename = "../kubespray/inventory/mycluster/hosts.yaml"

  depends_on = [
    module.all_nodes
  ]
}

resource "local_file" "inventory" {
  content = <<-DOC
---
all:
  hosts:
    kube_control_plane:
     ansible_host: ${module.all_nodes["control_plane"].external_ip_address_instance[0]}
     ansible_user: ${var.tf_user}
    DOC
  filename = "../ansible/inventory.yml"

  depends_on = [
    module.all_nodes
  ]
}

