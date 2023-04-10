output "public_web_address" {
  value = google_compute_global_address.public_ingress.address
}

output "gke_cluster_name" {
  value = module.gnomad-gke.gke_cluster_name
}
