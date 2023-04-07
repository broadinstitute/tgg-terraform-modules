module "gnomad-vpc" {
  source       = "github.com/broadinstitute/tgg-terraform-modules//vpc-with-nat-subnet?ref=vpc-with-nat-subnet-v0.0.1"
  network_name = var.network_name_prefix
  subnets = [
    {
      subnet_name_suffix           = "gke"
      subnet_region                = "us-east1"
      ip_cidr_range                = var.gke_primary_subnet_range
      enable_private_google_access = true
    },
    {
      subnet_name_suffix           = "dataproc"
      subnet_region                = "us-east1"
      ip_cidr_range                = var.dataproc_primary_subnet_range
      enable_private_google_access = true
    }
  ]
}

# Firewalls

# A document containing the Broad's public IP subnets for allowing Office and VPN IPs in firewalls
data "google_storage_bucket_object_content" "internal_networks" {
  count  = var.allow_broad_institute_networks ? 1 : 0
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

locals {
  broad_networks = length(data.google_storage_bucket_object_content.internal_networks) > 0 ? jsondecode(data.google_storage_bucket_object_content.internal_networks[0].content) : []
}

resource "google_compute_firewall" "dataproc_internal" {
  name        = "${var.network_name_prefix}-dataproc-internal-allow"
  network     = module.gnomad-vpc.network_name
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
  count   = var.allow_broad_institute_networks ? 1 : 0
  name    = "${var.network_name_prefix}-allow-ssh-broad-dataproc"
  network = module.gnomad-vpc.network_name

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
  name    = "${var.network_name_prefix}-iap-access"
  network = module.gnomad-vpc.network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}
