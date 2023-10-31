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
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_project_iam_member" "grant_user_os_login" {
  project = var.project_id
  role    = "roles/compute.osLogin"
  member  = "user:${var.user_principal}"
}

resource "google_storage_bucket" "user_dataproc_stage" {
  project                     = var.project_id
  name                        = "${var.dataproc_bucket_prefix}-stage"
  storage_class               = "STANDARD"
  location                    = "us-central1"
  force_destroy               = var.force_destroy_user_dataproc_buckets
  uniform_bucket_level_access = true
  labels = {
    "bucket" = format("%s-stage", var.dataproc_bucket_prefix)
    "owner"  = format("%s", split("@", var.user_principal)[0])
  }
}

resource "google_storage_bucket" "user_dataproc_temp" {
  project                     = var.project_id
  name                        = "${var.dataproc_bucket_prefix}-temp"
  storage_class               = "STANDARD"
  location                    = "us-central1"
  force_destroy               = var.force_destroy_user_dataproc_buckets
  uniform_bucket_level_access = true
  labels = {
    "bucket" = format("%s-temp", var.dataproc_bucket_prefix)
    "owner"  = format("%s", split("@", var.user_principal)[0])
  }
}

resource "google_storage_bucket_iam_member" "grant_user_dataproc_stage_write" {
  bucket = google_storage_bucket.user_dataproc_stage.name
  role   = "roles/storage.objectAdmin"
  member = "user:${var.user_principal}"
}

resource "google_storage_bucket_iam_member" "grant_user_dataproc_stage_legacy_write" {
  bucket = google_storage_bucket.user_dataproc_stage.name
  role   = "roles/storage.legacyBucketWriter"
  member = "user:${var.user_principal}"
}

resource "google_storage_bucket_iam_member" "grant_user_dataproc_temp_write" {
  bucket = google_storage_bucket.user_dataproc_temp.name
  role   = "roles/storage.objectAdmin"
  member = "user:${var.user_principal}"
}

resource "google_storage_bucket_iam_member" "grant_user_dataproc_temp_legacy_write" {
  bucket = google_storage_bucket.user_dataproc_temp.name
  role   = "roles/storage.legacyBucketWriter"
  member = "user:${var.user_principal}"
}

resource "google_storage_bucket_iam_member" "dataproc_sa_stage_write" {
  bucket = google_storage_bucket.user_dataproc_stage.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket_iam_member" "dataproc_sa_stage_legacy_write" {
  bucket = google_storage_bucket.user_dataproc_stage.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket_iam_member" "dataproc_sa_temp_write" {
  bucket = google_storage_bucket.user_dataproc_temp.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}

resource "google_storage_bucket_iam_member" "dataproc_sa_temp_legacy_write" {
  bucket = google_storage_bucket.user_dataproc_temp.name
  role   = "roles/storage.legacyBucketWriter"
  member = "serviceAccount:${var.service_account_email}"
}
