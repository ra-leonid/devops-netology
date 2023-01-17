variable "yc_token" {
  default = ""
  type = string
  sensitive = true
}

variable "yc_cloud_id" {
  default = ""
  type = string
  sensitive = true
}

variable "yc_folder_id" {
  default = ""
  type = string
  sensitive = true
}

variable "yc_region" {
  default = "ru-central1-a"
}

variable "image" {
  default = "ubuntu-2004-lts"
}

variable "tf_user" {
  default = "ubuntu"
}

variable "control_plane_instance_count" {
  default = 1
}

variable "slave_node_instance_count" {
  default = 2
}