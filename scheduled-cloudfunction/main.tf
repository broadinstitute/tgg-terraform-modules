resource "google_pubsub_topic" "scheduled_function_pubsub" {
  name = var.scheduled_function_name
}

resource "google_cloudfunctions_function" "scheduled-cloudfunction" {
  name                  = var.scheduled_function_name
  description           = var.scheduled_function_description
  runtime               = var.function_runtime
  ingress_settings      = "ALLOW_INTERNAL_ONLY"
  service_account_email = var.service_account_email
  timeout               = var.function_timeout
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  labels = {
    managed-by = "terraform"
  }

  available_memory_mb = var.memory_mb
  entry_point         = var.function_entrypoint

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.scheduled_function_pubsub.id
  }

  environment_variables = var.function_environment_variables

  source_repository {
    url = var.source_repository_url
  }

  lifecycle {
    ignore_changes = [
      labels["deployment-tool"]
    ]
  }
}

resource "google_cloud_scheduler_job" "cloud_scheduler_schedule" {
  name        = var.scheduled_function_name
  description = "Cron schedule for: ${var.scheduled_function_name}"
  schedule    = var.cron_schedule
  time_zone   = "America/New_York"

  pubsub_target {
    topic_name = google_pubsub_topic.scheduled_function_pubsub.id
    data       = base64encode("pleaserun")
  }
}
