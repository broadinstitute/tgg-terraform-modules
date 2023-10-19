output "gke_cluster_name" {
  value = module.gnomad-gke.gke_cluster_name
}

# for obtaining the internal network value that should be set in gnomad's PROXY_IPS env variable
output "gke_pods_ipv4_cidr_block" {
  value = module.gnomad-gke.gke_pods_ipv4_cidr_block
}

output "gke_cluster_api_endpoint" {
  value = module.gnomad-gke.gke_cluster_api_endpoint
}

output "gke_cluster_ca_cert" {
  value = module.gnomad-gke.gke_cluster_ca_cert
}
