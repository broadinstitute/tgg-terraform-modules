# Main cluster configuration
resource "google_container_cluster" "cluster" {
  provider                    = google-beta
  name                        = var.cluster_name
  project                     = var.project
  monitoring_service          = "monitoring.googleapis.com/kubernetes"
  network                     = "projects/${var.project}/global/networks/default"
  subnetwork                  = "projects/${var.project}/regions/us-central1/subnetworks/default"
  cluster_ipv4_cidr           = var.cluster_ipv4_cidr
  default_max_pods_per_node   = "110"
  enable_intranode_visibility = "false"
  enable_kubernetes_alpha     = "false"
  enable_legacy_abac          = "false"
  enable_shielded_nodes       = "false"
  enable_tpu                  = "false"
  initial_node_count          = var.cluster_initial_node_count
  location                    = var.cluster_location
  logging_service             = "logging.googleapis.com/kubernetes"
  networking_mode             = var.networking_mode
  remove_default_node_pool    = var.remove_default_node_pool

  addons_config {
    cloudrun_config {
      disabled = "true"
    }

    http_load_balancing {
      disabled = "false"
    }

    network_policy_config {
      disabled = "false"
    }
  }

  binary_authorization {
    evaluation_mode = "DISABLED"
  }

  cluster_autoscaling {
    enabled = "false"
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }

  database_encryption {
    state = "DECRYPTED"
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = var.recurring_maint_windows
      content {
        start_time = recurring_window.value.start_time
        end_time   = recurring_window.value.end_time
        recurrence = recurring_window.value.recurrence
      }
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maint_exclusions
      content {
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time
        exclusion_name = maintenance_exclusion.value.name

      }
    }
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "69.173.127.192/27"
    }

    cidr_blocks {
      cidr_block = "69.173.112.0/21"
    }

    cidr_blocks {
      cidr_block = "69.173.96.0/20"
    }

    cidr_blocks {
      cidr_block = "69.173.127.232/29"
    }

    cidr_blocks {
      cidr_block = "69.173.126.0/24"
    }

    cidr_blocks {
      cidr_block = "69.173.124.0/23"
    }

    cidr_blocks {
      cidr_block = "69.173.127.0/25"
    }

    cidr_blocks {
      cidr_block = "69.173.64.0/19"
    }

    cidr_blocks {
      cidr_block = "69.173.127.228/32"
    }

    cidr_blocks {
      cidr_block = "69.173.127.224/30"
    }

    cidr_blocks {
      cidr_block = "69.173.127.240/28"
    }

    cidr_blocks {
      cidr_block = "69.173.127.230/31"
    }

    cidr_blocks {
      cidr_block = "69.173.127.128/26"
    }

    cidr_blocks {
      cidr_block = "69.173.120.0/22"
    }
  }

  network_policy {
    enabled  = "true"
    provider = "CALICO"
  }


  release_channel {
    channel = "UNSPECIFIED"
  }

  dynamic "workload_identity_config" {
    for_each = var.workload_identity
    content {
      workload_pool = workload_identity_config.value.name
    }
  }

  resource_labels = var.gke_resource_labels
}

# Default node pool configuration
resource "google_container_node_pool" "default_pool" {
  project  = var.project
  cluster  = google_container_cluster.cluster.name
  location = var.cluster_location

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  name = "default-pool"

  node_config {
    disk_size_gb    = var.default_pool_disk_size
    disk_type       = "pd-standard"
    image_type      = var.default_pool_image_type
    local_ssd_count = "0"
    machine_type    = var.default_pool_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/devstorage.read_write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/logging.write"]
    preemptible     = "false"
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = "true"
      enable_secure_boot          = "false"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  node_count = var.default_pool_node_count

  upgrade_settings {
    max_surge       = "1"
    max_unavailable = "0"
  }
}
