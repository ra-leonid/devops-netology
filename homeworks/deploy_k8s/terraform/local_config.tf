
resource "null_resource" "local_config" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i inventory.yml local_config.yml"
    working_dir = "../ansible"
  }

  depends_on = [
    null_resource.kubespray
  ]
}
