output "public_web_address" {
  value = google_compute_global_address.public_ingress.address
}

output "gke_cluster_name" {
  value = module.gnomad-gke.gke_cluster_name
}

# for obtaining the internal network value that should be set in gnomad's PROXY_IPS env variable
output "gke_pods_ipv4_cidr_block" {
  value = module.gnomad-gke.gke_pods_ipv4_cidr_block
}
