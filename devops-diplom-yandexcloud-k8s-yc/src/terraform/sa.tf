resource "yandex_iam_service_account" "kube-admin" {
 name        = "kube-admin"
 description = "доуступ к клатеру куба"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor_netology-kube" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = var.yc_folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.kube-admin.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = var.yc_folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.kube-admin.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "load-balancer-admin" {
 # Сервисному аккаунту назначается роль "load-balancer.admin".
 folder_id = var.yc_folder_id
 role      = "load-balancer.admin"
 members   = [
   "serviceAccount:${yandex_iam_service_account.kube-admin.id}"
 ]
}

resource "yandex_iam_service_account" "ingress-admin" {
 name        = "ingress-admin"
 description = "админ ингресс"
}

resource "yandex_resourcemanager_folder_iam_binding" "alb-editor" {
 # Сервисному аккаунту назначается роль "alb.editor".
 folder_id = var.yc_folder_id
 role      = "alb.editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.ingress-admin.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc-publicAdmin" {
 # Сервисному аккаунту назначается роль "vpc.publicAdmin".
 folder_id = var.yc_folder_id
 role      = "vpc.publicAdmin"
 members   = [
   "serviceAccount:${yandex_iam_service_account.ingress-admin.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "compute-viewer" {
 # Сервисному аккаунту назначается роль "compute.viewer".
 folder_id = var.yc_folder_id
 role      = "compute.viewer"
 members   = [
   "serviceAccount:${yandex_iam_service_account.ingress-admin.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "certificate-manager-certificates-downloader" {
 # Сервисному аккаунту назначается роль "certificate-manager.certificates.downloader".
 folder_id = var.yc_folder_id
 role      = "certificate-manager.certificates.downloader"
 members   = [
   "serviceAccount:${yandex_iam_service_account.ingress-admin.id}"
 ]
}