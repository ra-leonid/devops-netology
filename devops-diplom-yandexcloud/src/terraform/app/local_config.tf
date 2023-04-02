
resource "null_resource" "local_config" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml site.yml"
    working_dir = "../../playbook"
  }

  depends_on = [
    null_resource.kubespray,
    local_file.local_inventory
  ]
}
