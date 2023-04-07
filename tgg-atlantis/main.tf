# include GKE cluster
data "google_storage_bucket_object_content" "internal_networks" {
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

module "atlantis-gke" {
  source           = "github.com/broadinstitute/tgg-terraform-modules//private-gke-cluster?ref=3d72a49349c979bda0b3de82d50dd07d23c4ff11"
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
      "pool_num_nodes"       = 3
      "pool_machine_type"    = "e2-medium"
      "pool_preemptible"     = true
      "pool_zone"            = ""
      "pool_resource_labels" = {}
    }
  ]
  vpc_network_name                      = var.vpc_network_name
  vpc_subnet_name                       = var.vpc_subnet_name
  gke_control_plane_authorized_networks = toset(jsondecode(data.google_storage_bucket_object_content.internal_networks.content))
}

# atlantis service account
resource "google_service_account" "atlantis_runner" {
  account_id   = "tgg-atlantis-runner"
  display_name = "TGG Atlantis Runner"
}

resource "google_service_account_iam_member" "atlantis_identity" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.atlantis_runner.name
  member             = "serviceAccount:tgg-automation.svc.id.goog[tgg-services/atlantis]"
}

# static IP, tls cert etc
resource "google_compute_global_address" "atlantis_ip" {
  name = "tgg-atlantis"
}

# Cloudarmor policy for restricting access to the atlantis events endpoint
data "github_ip_ranges" "github_hook_ips" {}

resource "google_compute_security_policy" "atlantis_cloudarmor_policy" {
  name = "atlantis-events-policy"

  # subnets for GitHub
  # only 10 cidrs allowed per rule
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

# Cloudarmor policy for restricting argocd UI access to Broad networks
data "google_storage_bucket_object_content" "broad_networks" {
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

resource "google_compute_security_policy" "argocd_cloudarmor_policy" {
  name = "argocd-policy"

  # subnets for the Broad
  rule {
    action   = "allow"
    priority = "0"

    match {
      versioned_expr = "SRC_IPS_V1"

      config {
        src_ip_ranges = jsondecode(data.google_storage_bucket_object_content.broad_networks.content)
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
