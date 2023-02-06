resource "google_storage_bucket" "general_use_bucket" {
  count         = var.create_default_buckets ? 1 : 0
  project       = google_project.current_project.project_id
  name          = "${var.project_id}-storage"
  location      = var.default_resource_region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

# TODO: add a -tmp-4day bucket for auto-deletion
resource "google_storage_bucket" "tmp_4day_bucket" {
  count         = var.create_default_buckets ? 1 : 0
  project       = google_project.current_project.project_id
  name          = "${var.project_id}-tmp-4day"
  location      = var.default_resource_region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = true

  lifecycle_rule {
    condition {
      age = 4
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}
