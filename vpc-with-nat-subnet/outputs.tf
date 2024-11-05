output "vpc_network_name" {
  value = google_compute_network.network.name
}

output "vpc_network_id" {
  value = google_compute_network.network.id
}

output "vpc_subnet_names" {
  value = [for subnet in google_compute_subnetwork.subnet : subnet.name]
}
