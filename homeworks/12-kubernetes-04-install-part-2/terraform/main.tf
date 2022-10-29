
module "vpc" {
  source  = "hamnsk/vpc/yandex"
  version = "0.5.0"
  description = "managed by terraform"
  create_folder = length(var.yc_folder_id) > 0 ? false : true
  yc_folder_id = var.yc_folder_id
  name = "net"
  subnets = local.vpc_subnets
}
module "all_nodes" {
  source = "./modules/instance"
  for_each = toset(local.stages)

  instance_count = local.instance_count[each.value]

  subnet_id     = module.vpc.subnet_ids[0]
  zone = var.yc_region
  image         = var.image
  name          = local.name_set[each.value]
  description   = "k8s ${each.value}"
  users         = var.tf_user
  cores         = local.cores[each.value]
  #boot_disk     = "network-ssd"
  boot_disk     = "network-hdd"
  disk_size     = local.disk_size[each.value]
  nat           = "true"
  memory        = local.memory[each.value]
  core_fraction = "100"
  depends_on = [
    module.vpc
  ]
}

locals {
  name_set = {
    control_plane = "control-plane"
    node = "node"
  }
  stages = [
    "control_plane",
    "node"
  ]
  instance_count = {
    control_plane = var.control_plane_instance_count
    node = var.slave_node_instance_count
  }
  cores = {
    control_plane = 2
    node = 2
  }
  disk_size = {
    control_plane = 50
    node = 100
  }
  memory = {
    control_plane = 2
    node = 2
  }
  vpc_subnets = [
    {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["192.168.0.0/24"]
    }
  ]
}
