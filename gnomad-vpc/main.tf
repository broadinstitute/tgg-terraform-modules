resource "google_compute_network" "network" {
  name                    = "${var.network_name_prefix}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gnomad_subnet" {
  name          = "${var.network_name_prefix}-gnomad-subnet"
  ip_cidr_range = "192.168.0.0/20"
  network       = google_compute_network.network.id

  secondary_ip_range = [
    {
      range_name    = "gke-services"
      ip_cidr_range = "10.0.32.0/20"
    },
    {
      range_name    = "gke-pods"
      ip_cidr_range = "10.4.0.0/14"
    }
  ]

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "EXCLUDE_ALL_METADATA"
  }
}

resource "google_compute_subnetwork" "dataproc_subnet" {
  name          = "${var.network_name_prefix}-dataproc-subnet"
  ip_cidr_range = "192.168.255.0/24"
  network       = google_compute_network.network.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "EXCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "router" {
  name    = "${var.network_name_prefix}-gnomad-nat"
  network = google_compute_network.network.id
}


resource "google_compute_router_nat" "router_nat" {
  name                               = "${var.network_name_prefix}-gnomad-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
