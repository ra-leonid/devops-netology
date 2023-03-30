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
  filename = "../../kubespray/inventory/mycluster/hosts.yaml"

  depends_on = [
    module.all_nodes
  ]
}

resource "local_file" "local_inventory" {
  content = <<-DOC
---
all:
  hosts:
    kube_control_plane:
     ansible_host: ${module.all_nodes["control_plane"].internal_ip_address_instance[0]}
     ansible_user: ${var.tf_user}
    bastion:
     ansible_host: ${module.vpc.nat_ip_address}
     ansible_user: ${var.tf_user}
    DOC
  filename = "../../playbook/inventory.yml"

  depends_on = [
    module.all_nodes
  ]
}

