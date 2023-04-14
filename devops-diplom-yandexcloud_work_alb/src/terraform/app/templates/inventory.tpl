---
all:
  hosts:
    kube_control_plane:
      ansible_host: ${ip_control_plane}
      ansible_user: ${ansible_user}
    bastion:
      ansible_host: ${bastion}
      ansible_user: ${ansible_user}
  vars:
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand=\"ssh -W %h:%p ${ansible_user}@${bastion} -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null\""