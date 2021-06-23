data "google_project" "project" {}

resource "google_service_account" "storage-cost-function" {
  account_id   = "${var.sa_name_prefix}-storage-monitor"
  display_name = "${var.sa_name_prefix} project Storage Cost Function"
}

resource "google_project_iam_member" "storage-cost-function-membership" {
  role   = "roles/monitoring.viewer"
  member = "serviceAccount:${google_service_account.storage-cost-function.email}"
}

resource "google_project_iam_custom_role" "storage-cost-list-buckets" {
  role_id     = "storageCostBucketList"
  title       = "Storage Cost Function Bucket List"
  description = "Allows for listing of buckets within the project"
  permissions = ["storage.buckets.list"]
}

resource "google_project_iam_member" "storage-cost-bucketlist-membership" {
  role   = google_project_iam_custom_role.storage-cost-list-buckets.id
  member = "serviceAccount:${google_service_account.storage-cost-function.email}"
}

resource "google_secret_manager_secret_iam_member" "storage-cost-function-secret-read-access" {
  secret_id = var.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.storage-cost-function.email}"
}

resource "google_pubsub_topic" "storage-cost-function" {
  name = "storage-cost-function-notifications"
}

resource "google_cloudfunctions_function" "storge-cost-monitoring" {
  name                  = "storage-cost-monitoring"
  description           = "Slack notifications for monitoring GCS storage costs"
  runtime               = "python39"
  ingress_settings      = "ALLOW_INTERNAL_ONLY"
  service_account_email = google_service_account.storage-cost-function.email
  labels = {
    managed-by = "terraform"
  }

  available_memory_mb = var.memory_mb
  entry_point         = "usage_monitoring"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.storage-cost-function.id
  }

  environment_variables = {
    GCP_PROJECT   = "${data.google_project.project.project_id}"
    SLACK_CHANNEL = "${var.slack_channel_name}"
  }

  source_repository {
    url = var.source_repository_url
  }

  lifecycle {
    ignore_changes = [
      labels["deployment-tool"]
    ]
  }
}

resource "google_cloud_scheduler_job" "storage_monitoring_schedule" {
  name        = "trigger-storage-monitoring"
  description = "The cron schedule on which to trigger the cost reporting function"
  schedule    = var.cron_schedule
  time_zone   = "America/New_York"

  pubsub_target {
    topic_name = google_pubsub_topic.storage-cost-function.id
    data       = base64encode("pleaserun")
  }
}
