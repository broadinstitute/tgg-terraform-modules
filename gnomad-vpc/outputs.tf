output "gnomad_subnet_secondary_ranges" {
  value       = [for range in google_compute_subnetwork.gnomad_subnet.secondary_ip_range : range.range_name]
  description = "The secondary ranges associated with the gnomad subnet"
}

output "gnomad_vpc_network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC network created by this module"
}

output "gnomad_vpc_network_gke_subnet_name" {
  value = google_compute_subnetwork.gnomad_subnet.name
}
