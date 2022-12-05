resource "google_compute_network" "network" {
  name                    = "${var.network_name_prefix}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gnomad_subnet" {
  name          = "${var.network_name_prefix}-gnomad-subnet"
  ip_cidr_range = var.gnomad_primary_subnet_range # "192.168.0.0/20"
  network       = google_compute_network.network.id

  secondary_ip_range = [
    {
      range_name    = "gke-services"
      ip_cidr_range = var.gke_services_secondary_range # "10.0.32.0/20"
    },
    {
      range_name    = "gke-pods"
      ip_cidr_range = var.gke_pods_secondary_range # "10.4.0.0/14"
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
  ip_cidr_range = var.dataproc_primary_subnet_range # "192.168.255.0/24"
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

# A document containing the Broad's public IP subnets for allowing Office and VPN IPs in firewalls
data "google_storage_bucket_object_content" "internal_networks" {
  count  = var.allow_broad_institute_networks ? 0 : 1
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

locals {
  broad_networks = length(data.google_storage_bucket_object_content.internal_networks) > 0 ? jsondecode(data.google_storage_bucket_object_content.internal_networks[0].content) : []
}

resource "google_compute_firewall" "dataproc_internal" {
  name        = "dataproc-internal-allow"
  network     = google_compute_network.network.name
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
  count   = var.allow_broad_institute_networks ? 0 : 1
  name    = "allow-ssh-broad-dataproc"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = toset(local.broad_networks)

  target_tags = [
    "dataproc-node"
  ]
}

# allows SSH access from the Identity Aware Proxy service (for cloud-console based SSH sessions)
resource "google_compute_firewall" "iap_forwarding" {
  name    = "iap-access"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}
