resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each      = { for subnet in var.subnets : subnet.subnet_name_suffix => subnet }
  name          = "${var.network_name}-${each.value.subnet_name_suffix}"
  ip_cidr_range = each.value.ip_cidr_range
  network       = google_compute_network.network.name

  private_ip_google_access = each.value.enable_private_google_access

  dynamic "log_config" {
    for_each = lookup(each.value, "subnet_flow_logs", false) ? [{
      aggregation_interval = lookup(each.value, "subnet_flow_logs_interval", "INTERVAL_5_SEC")
      flow_sampling        = lookup(each.value, "subnet_flow_logs_sampling", "0.5")
      metadata             = lookup(each.value, "subnet_flow_logs_metadata", "EXCLUDE_ALL_METADATA")
      filter_expr          = lookup(each.value, "subnet_flow_logs_filter", "true")
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
    }
  }
}

resource "google_compute_router" "router" {
  name    = "${var.network_name}-nat"
  network = google_compute_network.network.id
}


resource "google_compute_router_nat" "router_nat" {
  name                               = "${var.network_name}-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = var.nat_ips
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
