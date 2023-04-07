output "gnomad_vpc_network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC network created by this module"
}
