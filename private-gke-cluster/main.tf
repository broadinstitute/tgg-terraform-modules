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
    "storage.objectViewer",
    "artifactregistry.reader"
  ])

  role    = "roles/${each.key}"
  member  = google_service_account.gke_nodes.member
  project = var.project_name
}

# GKE Cluster
resource "google_container_cluster" "gke_cluster" {
  name                = var.gke_cluster_name
  network             = var.vpc_network_name
  subnetwork          = var.vpc_subnet_name
  networking_mode     = "VPC_NATIVE"
  location            = var.gke_control_plane_zone
  resource_labels     = var.resource_labels
  deletion_protection = var.deletion_protection

  master_authorized_networks_config {

    dynamic "cidr_blocks" {
      for_each = toset(var.gke_control_plane_authorized_networks)
      content {
        cidr_block = cidr_blocks.key
      }
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.gke_pods_range_slice
    services_ipv4_cidr_block = var.gke_services_range_slice
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
    channel = var.release_channel
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = var.gke_recurring_maint_windows
      content {
        start_time = recurring_window.value.start_time
        end_time   = recurring_window.value.end_time
        recurrence = recurring_window.value.recurrence
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.gke_maint_exclusions
      content {
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time
        exclusion_name = maintenance_exclusion.value.name

      }
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
