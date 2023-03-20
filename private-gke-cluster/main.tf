# Service account for GKE
resource "google_service_account" "gke_nodes" {
  account_id   = "${var.gke_cluster_name}-gke"
  display_name = "${var.gke_cluster_name} GKE Nodes"
}

# IAM role for GKE
resource "google_project_iam_member" "gke_nodes_iam" {
  for_each = toset([
    "logging.logWriter",
    "monitoring.metricWriter",
    "monitoring.viewer",
    "stackdriver.resourceMetadata.writer",
    "storage.objectViewer"
  ])

  role    = "roles/${each.key}"
  member  = google_service_account.gke_nodes.member
  project = var.project_name
}

# firewall for atlantis?
# Static IP for Atlantis / Ingress
# GKE Cluster
# A document containing the Broad's public IP subnets for allowing Office and VPN IPs in firewalls
data "google_storage_bucket_object_content" "internal_networks" {
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

resource "google_container_cluster" "gke_cluster" {
  name            = var.gke_cluster_name
  network         = var.vpc_network_name
  subnetwork      = var.vpc_subnet_name
  networking_mode = "VPC_NATIVE"
  resource_labels = var.resource_labels

  master_authorized_networks_config {

    dynamic "cidr_blocks" {
      for_each = jsondecode(data.google_storage_bucket_object_content.internal_networks.content)
      content {
        cidr_block = cidr_blocks.key
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_pods_range_name
    services_secondary_range_name = var.gke_services_range_name
  }

  # The google API won't allow creating clusters without node pools, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_name}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr_block
    enable_private_endpoint = false
  }

  release_channel {
    channel = "STABLE"
  }

  maintenance_policy {
    recurring_window {
      start_time = "1970-01-01T07:00:00Z"
      end_time   = "1970-01-01T11:00:00Z"
      recurrence = "FREQ=DAILY"
    }
  }
}

resource "google_container_node_pool" "node_pool" {
  for_each   = { for pool in var.node_pools : pool.pool_name => pool }
  name       = each.value.pool_name
  location   = each.value.pool_zone != "" ? each.value.pool_zone : var.gke_control_plane_zone
  cluster    = google_container_cluster.gke_cluster.name
  node_count = each.value.pool_num_nodes

  node_config {
    machine_type    = each.value.pool_machine_type
    preemptible     = each.value.pool_preemptible
    service_account = google_service_account.gke_nodes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    tags = ["${var.gke_cluster_name}", "${var.gke_cluster_name}-${each.value.pool_name}"]

    resource_labels = each.value.pool_resource_labels
  }
}
