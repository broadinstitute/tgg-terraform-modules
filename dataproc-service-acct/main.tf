resource "google_service_account" "dataproc_service_account" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

resource "google_service_account_iam_binding" "grant_sa_usage" {
  service_account_id = google_service_account.dataproc_service_account.id
  role               = "roles/iam.serviceAccountUser"

  members = ["user:${var.user_principal}"]
}

resource "google_project_iam_member" "grant_dataproc_editor" {
  project = var.project_id
  role    = "roles/dataproc.editor"
  member  = "user:${var.user_principal}"
}

resource "google_project_iam_member" "grant_user_service_usage" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "user:${var.user_principal}"
}

resource "google_project_iam_member" "grant_sa_service_usage" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}


resource "google_storage_bucket" "user_dataproc_stage" {
  project       = var.project_id
  name          = "${var.dataproc_bucket_prefix}-stage"
  storage_class = "STANDARD"
  location      = "us-central1"
  force_destroy = var.force_destroy_user_dataproc_buckets
  labels = {
    "bucket" = "${var.dataproc_bucket_prefix}-stage"
    "owner"  = "${var.user_principal}"
  }
}

resource "google_storage_bucket" "user_dataproc_temp" {
  project       = var.project_id
  name          = "${var.dataproc_bucket_prefix}-temp"
  storage_class = "STANDARD"
  location      = "us-central1"
  force_destroy = var.force_destroy_user_dataproc_buckets
  labels = {
    "bucket" = "${var.dataproc_bucket_prefix}-temp"
    "owner"  = "${var.user_principal}"
  }
}

resource "google_storage_bucket_iam_member" "grant_user_dataproc_stage_write" {
  bucket = google_storage_bucket.user_dataproc_stage.name
  role   = "roles/storage.objectAdmin"
  member = "user:${var.user_principal}"
}

resource "google_storage_bucket_iam_member" "grant_user_dataproc_temp_write" {
  bucket = google_storage_bucket.user_dataproc_temp.name
  role   = "roles/storage.objectAdmin"
  member = "user:${var.user_principal}"
}

resource "google_storage_bucket_iam_member" "dataproc_sa_stage_write" {
  bucket = google_storage_bucket.user_dataproc_stage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}

resource "google_storage_bucket_iam_member" "dataproc_sa_temp_write" {
  bucket = google_storage_bucket.user_dataproc_temp.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataproc_service_account.email}"
}
