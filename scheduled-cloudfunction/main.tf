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
  count        = var.manage_service_accounts ? 1 : 0
  account_id   = var.scheduled_function_name
  project      = var.project_id
  display_name = "Service account for scheduled function: ${var.scheduled_function_name}"
}

resource "google_service_account_iam_member" "cloudbuild_impersonate" {
  count              = var.manage_service_accounts ? 1 : 0
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

resource "google_service_account" "deployment_service_account" {
  count        = var.manage_service_accounts ? 1 : 0
  account_id   = "${var.scheduled_function_name}-deployer"
  project      = var.project_id
  display_name = "Service account for scheduled function deployment: ${var.scheduled_function_name}"
}

resource "google_project_iam_member" "deployment_service_account_project_permissions" {
  count   = var.manage_service_accounts ? 1 : 0
  project = var.project_id
  role    = "roles/cloudfunctions.admin"
  member  = google_service_account.deployment_service_account.member
}

resource "google_service_account_iam_member" "deployer_impersonate" {
  count              = var.manage_service_accounts ? 1 : 0
  service_account_id = google_service_account.scheduled_function_service_account.name
  role               = "roles/iam.serviceAccountUser"
  member             = google_service_account.deployment_service_account.member
}

module "gh_oidc_wif" {
  count       = var.configure_workload_identity ? 1 : 0
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version     = "3.1.1"
  project_id  = var.project_id
  pool_id     = "${var.scheduled_function_name}-actions-pool"
  provider_id = "${var.scheduled_function_name}-github-actions"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }
  attribute_condition = var.workload_identity_attr_condition
  sa_mapping = {
    "${var.scheduled_function_name}-deployer" = {
      sa_name   = google_service_account.deployment_service_account.id
      attribute = var.workload_identity_attr
    }
  }
}


output "scheduled_function_trigger_topic" {
  value = google_pubsub_topic.scheduled_function_trigger_topic.name
}

output "service_account_member" {
  value = var.manage_service_accounts ? google_service_account.scheduled_function_service_account.member : null
}

output "deployment_service_account_member" {
  value = var.manage_service_accounts ? google_service_account.deployment_service_account.member : null
}

output "scheduled_function_name" {
  value = var.scheduled_function_name
}
