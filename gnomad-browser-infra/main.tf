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
