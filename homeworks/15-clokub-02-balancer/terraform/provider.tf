# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.88.0"
    }
  }
}

provider "yandex" {
  # yc_token, yc_folder_id, yc_cloud_id хранятся локально в файле terraform.tfvars
  # Для использования переменных, объявляем их в файле variables.tf, но не заполняем
  token     = var.yc_token
  folder_id = var.yc_folder_id
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region
}
