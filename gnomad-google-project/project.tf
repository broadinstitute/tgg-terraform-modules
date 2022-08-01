resource "random_id" "random_project_id_suffix" {
  byte_length = 2
}

resource "google_project" "current_project" {
  name                = var.project_name
  project_id          = format("%s-%s", var.project_id, random_id.random_project_id_suffix.hex)
  folder_id           = format("folders/%s", var.folder_id)
  billing_account     = var.billing_account_id
  auto_create_network = false
}

resource "google_project_iam_member" "default_compute_admin" {
  project = google_project.current_project.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${data.google_service_account.default_compute_sa.email}"
}

resource "google_project_iam_member" "default_compute_dataproc_worker" {
  project = google_project.current_project.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${data.google_service_account.default_compute_sa.email}"
}

resource "google_project_iam_member" "default_compute_object_admin" {
  project = google_project.current_project.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${data.google_service_account.default_compute_sa.email}"
}
