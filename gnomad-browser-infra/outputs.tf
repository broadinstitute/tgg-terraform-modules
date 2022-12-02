output "public_web_address" {
  value = google_compute_global_address.public_ingress.address
}

output "gke_cluster_name" {
  value = google_container_cluster.browser_cluster.name
}

output "auth_networks" {
  value = local.broad_networks
}
