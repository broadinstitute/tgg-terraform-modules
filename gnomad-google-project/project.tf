resource "random_id" "random_project_id_suffix" {
  byte_length = 2
}

resource "google_project" "current_project" {
  name                = var.project_name
  project_id          = format("%s-%s", var.project_id, random_id.random_project_id_suffix.hex)
  folder_id           = format("folders/%s", var.gcp_folder_id)
  billing_account     = var.billing_account_id
  auto_create_network = false

  lifecycle {
    ignore_changes = [
      labels,
    ]
  }
}

resource "google_project_iam_member" "default_compute_admin" {
  project = google_project.current_project.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_project.current_project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "default_compute_dataproc_worker" {
  project = google_project.current_project.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_project.current_project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "default_compute_object_admin" {
  project = google_project.current_project.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_project.current_project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_custom_role" "bucket_list_role" {
  role_id     = "gnomADProjBucketList"
  title       = "gnomAD Project Bucket List"
  description = "Provides access to list GCS buckets"
  permissions = ["storage.buckets.list"]
}

resource "google_project_iam_member" "default_compute_bucket_list" {
  project = google_project.current_project.project_id
  role    = google_project_iam_custom_role.bucket_list_role.role_id
  member  = "serviceAccount:${google_project.current_project.number}-compute@developer.gserviceaccount.com"
}

resource "google_project_iam_member" "owner_group" {
  project = google_project.current_project.project_id
  role    = "roles/owner"
  member  = "group:${var.owner_group_id}"
}
