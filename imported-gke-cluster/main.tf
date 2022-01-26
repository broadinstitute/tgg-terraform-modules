resource "google_container_cluster" "cluster" {
  name                        = var.cluster_name
  location                    = var.cluster_location
  default_max_pods_per_node   = 110
  enable_intranode_visibility = false
  enable_shielded_nodes       = var.shielded_nodes
  enable_tpu                  = var.enable_tpu
  initial_node_count          = var.initial_node_count
  remove_default_node_pool    = var.remove_default_node_pool

  network    = var.network_id
  subnetwork = var.subnetwork_id

  resource_labels = var.resource_labels

  maintenance_policy {

    recurring_window {
      start_time = var.maint_start_time
      end_time   = var.maint_end_time
      recurrence = var.maint_recurrence_sched
    }
  }

  ip_allocation_policy { # forces replacement
    cluster_ipv4_cidr_block  = var.cluster_v4_cidr
    services_ipv4_cidr_block = var.services_v4_cidr
  }
}
