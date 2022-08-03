data "google_storage_bucket_object_content" "internal_networks" {
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

data "google_service_account" "default_compute_sa" {
  account_id = "${google_project.current_project.number}-compute@developer.gserviceaccount.com"
}
