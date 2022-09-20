output "service_account_email" {
  value = google_service_account.dataproc_service_account.email
}

output "dataproc_temp_bucket_name" {
  value = google_storage_bucket.user_dataproc_temp.name
}

output "dataproc_stage_bucket_name" {
  value = google_storage_bucket.user_dataproc_stage.name
}
