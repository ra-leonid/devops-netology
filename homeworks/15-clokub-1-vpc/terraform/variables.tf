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

variable "family_id" {
  default = "ubuntu-2004-lts"
}

variable "tf_user" {
  default = "ubuntu"
}