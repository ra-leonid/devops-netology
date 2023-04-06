---
all:
  hosts:
    kube_control_plane:
      ansible_host: ${ip_control_plane}
      ansible_user: ${ansible_user}
    bastion:
      ansible_host: ${bastion}
      ansible_user: ${ansible_user}