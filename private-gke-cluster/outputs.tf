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
  value = google_container_cluster.gke_cluster.private_cluster_config[0].master_ipv4_cidr_block
}

# ipv4 cidr block for pods running in the cluster
output "gke_pods_ipv4_cidr_block" {
  value = google_container_cluster.gke_cluster.ip_allocation_policy[0].cluster_ipv4_cidr_block
}

output "gke_services_ipv4_cidr_block" {
  value = google_container_cluster.gke_cluster.ip_allocation_policy[0].services_ipv4_cidr_block
}

# cluster API endpoint
output "gke_cluster_api_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

# cluster CA certificate
output "gke_cluster_ca_cert" {
  value = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}
