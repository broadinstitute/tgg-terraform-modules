# include GKE cluster

module "atlantis-gke" {
  source           = "github.com/broadinstitute/tgg-terraform-modules//private-gke-cluster?ref=bc1853e79f848c52ae014cf0210f78fa9fc8481c"
  gke_cluster_name = "tgg-atlantis"
  project_name     = "tgg-automation"
  resource_labels = {
    "terraform"  = "true"
    "deployment" = "atlantis"
    "component"  = "gke"
  }
  node_pools = [
    {
      "pool_name"            = "main-pool"
      "pool_num_nodes"       = 2
      "pool_machine_type"    = "e2-standard-2"
      "pool_preemptible"     = true
      "pool_zone"            = ""
      "pool_resource_labels" = {}
    }
  ]
  vpc_network_name = var.vpc_network_name
  vpc_subnet_name  = var.vpc_subnet_name
}

# atlantis service account
resource "google_service_account" "atlantis_runner" {
  account_id   = "tgg-atlantis-runner"
  display_name = "TGG Atlantis Runner"
}

resource "google_service_account_iam_member" "atlantis_identity" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.atlantis_runner.name
  member             = "serviceAccount:tgg-automation.svc.id.goog[atlantis/atlantis]"
}

# static IP, tls cert etc
resource "google_compute_global_address" "atlantis_ip" {
  name = "tgg-atlantis"
}

# Cloudarmor policy for restricting access to the atlantis events endpoint
data "github_ip_ranges" "github_hook_ips" {}

resource "google_compute_security_policy" "atlantis_cloudarmor_policy" {
  name = "atlantis-events-policy"

  # subnets for the Broad
  # only 5 cidrs allowed per rule
  rule {
    action   = "allow"
    priority = "0"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = data.github_ip_ranges.github_hook_ips.hooks
      }
    }
  }

  # deny traffic here that doesn't match any of the above rules
  rule {
    action      = "deny(403)"
    priority    = "2147483647"
    description = "Default rule: deny all"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
