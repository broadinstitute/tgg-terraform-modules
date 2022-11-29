resource "google_service_account" "gke_cluster_sa" {
  account_id   = "${var.infra_prefix}-gke-nodes"
  description  = "The service account to run the GKE nodes with"
  display_name = "${var.infra_prefix} GKE nodes"
}

resource "google_project_iam_member" "gke_nodes_iam" {
  for_each = toset([
    "logging.logWriter",
    "monitoring.metricWriter",
    "monitoring.viewer",
    "stackdriver.resourceMetadata.writer",
    "storage.objectViewer"
  ])

  role    = "roles/${each.key}"
  member  = "serviceAccount:${google_service_account.gke_cluster_sa.email}"
  project = var.project_id
}

resource "google_container_cluster" "browser_cluster" {
  name     = "${var.infra_prefix}-cluster"
  location = var.gke_control_plane_zone

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes   = true
    master_ipv4_cidr_block = var.gke_control_plane_cidr_range
  }
}

resource "google_container_node_pool" "main_pool" {
  name       = "main-pool"
  location   = var.gke_main_pool_zone != "" ? var.gke_main_pool_zone : var.gke_control_plane_zone
  cluster    = google_container_cluster.browser_cluster.name
  node_count = var.main_pool_num_nodes

  node_config {
    preemptible  = true
    machine_type = var.main_pool_machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
