resource "google_artifact_registry_repository" "gnomad_repository" {
  location               = var.location
  project                = var.project_id
  repository_id          = "gnomad"
  description            = "docker repository for gnomAD images"
  format                 = "DOCKER"
  cleanup_policy_dry_run = var.cleanup_policy_dry_run
  # Cleanup Policy durations MUST be specified in seconds
  cleanup_policies {
    id     = "delete-demo"
    action = "DELETE"
    condition {
      tag_state    = "TAGGED"
      tag_prefixes = ["demo"]
      older_than   = "7776000s" # 90 days
    }
  }
  cleanup_policies {
    id     = "delete-older-than-1y"
    action = "DELETE"
    condition {
      tag_state  = "ANY"
      older_than = "31536000s" # 1 year
    }
  }
  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      package_name_prefixes = ["gnomad", "exome-results", "legacy-redirects"]
      keep_count            = 5
    }
  }
}

