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

variable "yc_key_file" {
  default = "./secrets/key.json"
}
