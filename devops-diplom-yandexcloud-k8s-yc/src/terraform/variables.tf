variable "ssh-keys" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "tf_user" {
  default = "ubuntu"
}

variable "url" {
  default = ""
}
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

variable "k8s_version" {
  default = "1.23"
  type = string
}
