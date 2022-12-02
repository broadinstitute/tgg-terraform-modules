resource "google_service_account" "gke_cluster_sa" {
  account_id   = "${var.infra_prefix}-gke-nodes"
  description  = "The service account to run the GKE nodes with"
  display_name = "${var.infra_prefix} GKE nodes"
}

resource "google_service_account" "es_snapshots" {
  account_id   = "${var.infra_prefix}-es-snaps"
  description  = "The service account for the elasticsearch snapshot lifecycle manager"
  display_name = "${var.infra_prefix} Elasticsearch Snapshots"
}

resource "google_service_account" "data_pipeline" {
  account_id   = "${var.infra_prefix}-data-pipeline"
  description  = "The service account for running the gnomAD data pipeline"
  display_name = "${var.infra_prefix} Data pipeline Service Account"
}

resource "google_project_iam_member" "gke_nodes_iam" {
  for_each = toset([
    "logging.logWriter",
    "monitoring.metricWriter",
    "monitoring.viewer",
    "stackdriver.resourceMetadata.writer",
    "storage.objectViewer"
  ])

  role    = "roles/${each.key}"
  member  = google_service_account.gke_cluster_sa.member
  project = var.project_id
}

resource "google_project_iam_member" "data_pipeline_dataproc_worker" {
  role    = "roles/dataproc.worker"
  member  = google_service_account.data_pipeline.member
  project = var.project_id
}

# required for requesterPays resources
resource "google_project_iam_member" "data_pipeline_service_consumer" {
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = google_service_account.data_pipeline.member
  project = var.project_id
}

resource "google_service_account_iam_member" "es_snapshots" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.es_snapshots.name
  member             = "serviceAccount:${var.project_id}.svc.id.goog[elasticsearch/es-snaps]"
}

resource "google_storage_bucket_iam_member" "es_snapshots" {
  bucket = google_storage_bucket.elastic_snapshots.name
  role   = "roles/storage.admin"
  member = google_service_account.es_snapshots.member
}

resource "google_storage_bucket_iam_member" "data_pipeline" {
  bucket = google_storage_bucket.data_pipeline.name
  role   = "roles/storage.admin"
  member = google_service_account.data_pipeline.member
}

resource "google_storage_bucket" "elastic_snapshots" {
  name                        = "${var.infra_prefix}-elastic-snaps"
  location                    = var.es_snapshots_bucket_location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = {
    "deployment" = var.infra_prefix
    "terraform"  = "true"
    "component"  = "elasticsearch"
  }
}

resource "google_storage_bucket" "data_pipeline" {
  name                        = "${var.infra_prefix}-data-pipeline"
  location                    = var.data_pipeline_bucket_location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = {
    "deployment" = var.infra_prefix
    "terraform"  = "true"
    "component"  = "data-pipeline"
  }
}

# A document containing the Broad's public IP subnets for allowing Office and VPN IPs in firewalls
data "google_storage_bucket_object_content" "internal_networks" {
  count  = var.gke_include_broad_inst_authorized_networks ? 1 : 0
  name   = "internal_networks.json"
  bucket = "broad-institute-networking"
}

locals {
  broad_networks = length(data.google_storage_bucket_object_content.internal_networks) > 0 ? jsondecode(data.google_storage_bucket_object_content.internal_networks[0].content) : []
}


resource "google_container_cluster" "browser_cluster" {
  name            = "${var.infra_prefix}-cluster"
  location        = var.gke_control_plane_zone
  network         = var.vpc_network_name
  subnetwork      = var.vpc_subnet_name
  networking_mode = "VPC_NATIVE"
  resource_labels = {
    "deployment" = var.infra_prefix
    "terraform"  = "true"
    "component"  = "gke"
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = toset(var.gke_control_plane_authorized_networks)
      content {
        cidr_block = cidr_blocks.key
      }
    }

    dynamic "cidr_blocks" {
      for_each = toset(local.broad_networks)
      content {
        cidr_block = cidr_blocks.key
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.gke_cluster_secondary_range_name
    services_secondary_range_name = var.gke_services_secondary_range_name
  }

  # The google API won't allow creating clusters without node pools, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_control_plane_cidr_range
    enable_private_endpoint = false
  }

  release_channel {
    channel = "STABLE"
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = var.gke_recurring_maint_windows
      content {
        start_time = recurring_window.value.start_time
        end_time   = recurring_window.value.end_time
        recurrence = recurring_window.value.recurrence
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.gke_maint_exclusions
      content {
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time
        exclusion_name = maintenance_exclusion.value.name

      }
    }
  }

}

resource "google_container_node_pool" "main_pool" {
  name       = "main-pool"
  location   = var.gke_main_pool_zone != "" ? var.gke_main_pool_zone : var.gke_control_plane_zone
  cluster    = google_container_cluster.browser_cluster.name
  node_count = var.gke_main_pool_num_nodes

  node_config {
    preemptible  = true
    machine_type = var.gke_main_pool_machine_type

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.gke_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    tags = ["${var.infra_prefix}-gke", "${var.infra_prefix}-gke-main"]

  }
}

resource "google_container_node_pool" "redis_pool" {
  name       = "redis"
  location   = var.gke_redis_pool_zone != "" ? var.gke_redis_pool_zone : var.gke_control_plane_zone
  cluster    = google_container_cluster.browser_cluster.name
  node_count = var.gke_redis_pool_num_nodes

  node_config {
    machine_type = var.gke_redis_pool_machine_type

    service_account = google_service_account.gke_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    tags = ["${var.infra_prefix}-gke", "${var.infra_prefix}-gke-redis"]

  }
}

resource "google_container_node_pool" "es_data_pool" {
  name       = "es-data"
  location   = var.gke_es_data_pool_zone != "" ? var.gke_es_data_pool_zone : var.gke_control_plane_zone
  cluster    = google_container_cluster.browser_cluster.name
  node_count = var.gke_es_data_pool_num_nodes

  node_config {
    machine_type    = var.gke_es_data_pool_machine_type
    service_account = google_service_account.gke_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    tags = ["${var.infra_prefix}-gke", "${var.infra_prefix}-gke-es-data"]

  }
}

resource "google_compute_firewall" "es_webbook" {
  name        = "${var.vpc_network_name}-es-webhook"
  network     = var.vpc_network_name
  description = "Creates firewall rule allowing ECK admission webhook"

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }

  source_ranges = [var.gke_control_plane_cidr_range]
  target_tags   = ["${var.infra_prefix}-gke-es-data"]
}

resource "google_compute_global_address" "public_ingress" {
  name = "${var.infra_prefix}-global-ip"
}
