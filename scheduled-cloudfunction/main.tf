resource "google_pubsub_topic" "scheduled_function_trigger_topic" {
  name    = var.scheduled_function_name
  project = var.project_id
}

resource "google_cloud_scheduler_job" "cloud_scheduler_schedule" {
  name        = var.scheduled_function_name
  project     = var.project_id
  description = "Cron schedule for: ${var.scheduled_function_name}"
  schedule    = var.cron_schedule
  time_zone   = "America/New_York"

  pubsub_target {
    topic_name = google_pubsub_topic.scheduled_function_trigger_topic.id
    data       = base64encode("pleaserun")
  }
}

resource "google_service_account" "scheduled_function_service_account" {
  account_id   = var.scheduled_function_name
  project      = var.project_id
  display_name = "Service account for scheduled function: ${var.scheduled_function_name}"
}

resource "google_service_account_iam_member" "cloudbuild_impersonate" {
  service_account_id = google_service_account.scheduled_function_service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.cloudbuild_service_account_email}"
}

resource "google_project_iam_member" "service_account_project_permissions" {
  for_each = toset(var.service_account_roles)
  project  = var.project_id
  role     = each.value
  member   = google_service_account.scheduled_function_service_account.member
}

resource "google_secret_manager_secret_iam_member" "function_secret_access" {
  for_each  = toset(var.required_gcp_secrets)
  secret_id = each.value
  role      = "roles/secretmanager.secretAccessor"
  member    = google_service_account.scheduled_function_service_account.member
}

output "scheduled_function_trigger_topic" {
  value = google_pubsub_topic.scheduled_function_trigger_topic.name
}

output "service_account_member" {
  value = google_service_account.scheduled_function_service_account.member
}

output "scheduled_function_name" {
  value = var.scheduled_function_name
}
