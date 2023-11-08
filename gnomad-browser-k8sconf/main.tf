# Expected configuration for the browser deployments PROXY_IPS environment variable
locals {
  static_ip = var.public_ingress_ip == null ? "" : ",${var.public_ingress_ip}"
}


resource "kubernetes_config_map" "gnomad_proxy_ips" {
  metadata {
    name = "proxy-ips"
  }
  data = {
    ips = "127.0.0.1,${var.gke_vpc_ip_cidr_range},${var.gke_pods_ipv4_cidr_block},${var.gke_services_ipv4_cidr_block},35.191.0.0/16,130.211.0.0/22${var.public_ingress_ip}"
  }
}

# Pre-configures the service account that we use for ES snapshots
resource "kubernetes_service_account" "es_snaps" {
  count = var.es_snapshots_email == null ? 0 : 1
  metadata {
    name = "es-snaps"
    annotations = {
      "iam.gke.io/gcp-service-account" = var.es_snapshots_email
    }
  }
}
