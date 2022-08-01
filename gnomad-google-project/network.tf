resource "google_compute_network" "project_network" {
  project                 = google_project.current_project.project_id
  name                    = format("%s-network", var.project_id)
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "dataproc_internal" {
  count       = var.enable_default_services ? 1 : 0
  project     = google_project.current_project.project_id
  name        = "dataproc-internal-allow"
  network     = google_compute_network.project_network.name
  description = "Creates firewall rule allowing dataproc tagged instances to reach eachother"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_tags = ["dataproc-node"]
  target_tags = ["dataproc-node"]
}

resource "google_compute_firewall" "allow_ssh_broad_access" {
  count   = var.allow_broad_inst_ssh_access ? 1 : 0
  name    = "allow-ssh-broad"
  network = google_compute_network.my-network.name
  project = google_compute_network.my-network.project

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = jsondecode(data.google_storage_bucket_object_content.internal_networks.content)

  target_tags = [
    "ssh-broad"
  ]
}
