resource "local_file" "inventory" {
  content = templatefile("templates/inventory.tpl",
    {
      ip_control_plane = module.all_nodes["control_plane"].internal_ip_address_instance[0]
      bastion = module.vpc.nat_ip_address
      ansible_user = var.tf_user
    }
  )

  filename = "../../playbook/inventory.yml"

  depends_on = [
    module.all_nodes
  ]
}

resource "local_file" "qbec_group_vars_localhost" {
  content = templatefile("templates/group_vars_localhost.tpl",
    {
      namespace = terraform.workspace
      url: var.url
    }
  )
  filename = "../../playbook/group_vars/all/localhost/vars.yml"

  depends_on = [
    module.all_nodes
  ]
}

#resource "null_resource" "setting_up_access" {
#  provisioner "local-exec" {
#    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml --private-key ~/.ssh/id_rsa -e '{\"ansible_ssh_common_args\":\"-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\\\"ssh -W %h:%p ${var.tf_user}@${module.vpc.nat_ip_address} -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\\\"\"}' configuring_access_to_k8s.yml"
#    working_dir = "../../playbook"
#  }
#
#  depends_on = [
#    null_resource.kubespray,
#    local_file.inventory
#  ]
#}
#
#resource "null_resource" "configuration_qbec" {
#  provisioner "local-exec" {
#    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml configuration_qbec.yml"
#    working_dir = "../../playbook"
#  }
#
#  depends_on = [
#    null_resource.kubespray,
#    local_file.qbec_group_vars_localhost,
#    null_resource.setting_up_access
#  ]
#}
