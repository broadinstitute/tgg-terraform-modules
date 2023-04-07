# service account email
output "gke_service_account_email" {
  value = google_service_account.gke_nodes.email
}

# cluster name
output "gke_cluster_name" {
  value = google_container_cluster.gke_cluster.name
}

# ipv4 control plane cidr
output "gke_control_plane_cidr" {
  value = google_container_cluster.gke_cluster.private_cluster_config.master_ipv4_cidr_block
}
