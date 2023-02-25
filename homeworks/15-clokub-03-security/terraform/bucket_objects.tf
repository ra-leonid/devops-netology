resource "yandex_storage_object" "test-object" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "netology.15.02.raleonid"
  key        = "devops.jpg"
  source     = "./data/devops.jpg"
  depends_on = [
    yandex_storage_bucket.netology-bucket
  ]
}
