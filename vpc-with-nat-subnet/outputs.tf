output "vpc_network_name" {
  value = google_compute_network.network.name
}

output "vpc_subnet_name" {
  value = google_compute_subnetwork.subnet.name
}
