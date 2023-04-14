
output "kube-cluster-ext-endpoint" {
 value = yandex_kubernetes_cluster.cluster-kube.master[0].external_v4_endpoint
}

output "kube-cluster-ca-cert" {
  value = yandex_kubernetes_cluster.cluster-kube.master[0].cluster_ca_certificate
}
