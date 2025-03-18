resource "google_container_node_pool" "node_pool" {
  cluster  = var.cluster_name
  location = var.node_location

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  name = var.node_pool_name

  node_config {
    disk_size_gb = "100"
    disk_type    = "pd-standard"
    image_type   = var.node_pool_image_type

    labels = var.node_pool_labels

    # Per note here: https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/local-ssd#creating_a_node_pool_using_ephemeral_storage_on_local_ssds
    # we prefer ephemeral-storage-local-ssd to take advantage of NVMe.
    local_ssd_count = 0
    machine_type    = var.node_pool_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/devstorage.read_write", "https://www.googleapis.com/auth/monitoring", "https://www.googleapis.com/auth/logging.write"]
    preemptible     = var.preemptible_nodes
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = "true"
      enable_secure_boot          = "false"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    kubelet_config {
      cpu_cfs_quota  = false
      pod_pids_limit = 0
    }

    dynamic "ephemeral_storage_local_ssd_config" {
      for_each = (var.node_pool_local_ssd_count > 0) ? [var.node_pool_local_ssd_count] : []
      content {
        local_ssd_count  = var.node_pool_local_ssd_count
      }
    }

    lifecycle {
      ignore_changes = [
        kubelet_config
      ]
    }
  }

  node_locations = [var.node_location]

  upgrade_settings {
    max_surge       = "1"
    max_unavailable = "0"
  }

  node_count         = (var.max_node_pool_count > 0) ? null : var.min_node_pool_count
  dynamic "autoscaling" {
    for_each = (var.min_node_pool_count > 0 && var.max_node_pool_count > 0) ? [1] : []
    content {
      min_node_count = var.min_node_pool_count
      max_node_count = var.max_node_pool_count
    }
  }
}
