resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.network_name}-${var.subnet_name_suffix}"
  ip_cidr_range = var.primary_subnet_cidr
  network       = google_compute_network.network.name

  secondary_ip_range = var.secondary_ranges



  private_ip_google_access = var.enable_google_private_access

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "EXCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.network_name}-nat"
  network = google_compute_network.network.id
}


resource "google_compute_router_nat" "router_nat" {
  name                               = "${var.network_name}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
