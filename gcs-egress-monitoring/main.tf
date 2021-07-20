resource "google_monitoring_alert_policy" "gcs_bucket_egress_alarm" {
  display_name = "bucket egress"
  combiner     = "OR"
  conditions {
    display_name = "GCS storage egress has exceeded the allowed threshold"
    condition_threshold {
      filter          = "metric.type=\"storage.googleapis.com/network/sent_bytes_count\" resource.type=\"gcs_bucket\" resource.label.\"bucket_name\"=\"${var.gcs_bucket_name}\""
      duration        = var.sent_bytes_alerting_duration
      comparison      = "COMPARISON_GT"
      threshold_value = var.sent_bytes_alerting_threshold
      aggregations {
        alignment_period   = var.sent_bytes_alerting_alignment_period
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels
}
