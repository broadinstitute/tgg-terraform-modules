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

    local_ssd_count = var.node_pool_local_ssd_count
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
  }

  node_count     = var.node_pool_count
  node_locations = [var.node_location]

  upgrade_settings {
    max_surge       = "1"
    max_unavailable = "0"
  }
}
