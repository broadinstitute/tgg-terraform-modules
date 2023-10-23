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
  member             = "serviceAccount:${var.project_id}.svc.id.goog[default/es-snaps]"
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

module "gnomad-gke" {
  source                 = "github.com/broadinstitute/tgg-terraform-modules//private-gke-cluster?ref=private-gke-cluster-v1.0.3"
  gke_cluster_name       = var.infra_prefix
  project_name           = var.project_id
  gke_control_plane_zone = var.gke_control_plane_zone
  resource_labels = {
    "terraform"  = "true"
    "deployment" = "gnomad_browser"
    "component"  = "gke"
  }
  node_pools = var.gke_node_pools

  vpc_network_name                      = var.vpc_network_name
  vpc_subnet_name                       = var.vpc_subnet_name
  gke_control_plane_authorized_networks = toset(var.gke_control_plane_authorized_networks)
  gke_recurring_maint_windows           = var.gke_recurring_maint_windows
  gke_maint_exclusions                  = var.gke_maint_exclusions
  gke_pods_range_slice                  = var.gke_pods_range_slice
  gke_services_range_slice              = var.gke_services_range_slice
}

resource "google_compute_firewall" "es_webbook" {
  name        = "${var.vpc_network_name}-es-webhook"
  network     = var.vpc_network_name
  description = "Creates firewall rule allowing ECK admission webhook"

  allow {
    protocol = "tcp"
    ports    = ["9443"]
  }

  source_ranges = [module.gnomad-gke.gke_control_plane_cidr]
  target_tags   = ["${var.infra_prefix}-gke"]
}

data "google_compute_subnetwork" "gke_vpc" {
  name = var.vpc_subnet_name
}

locals {
  static_ip = var.public_static_ip == null ? "" : ",${var.public_static_ip}"
}

# Expected configuration for the browser deployments PROXY_IPS environment variable
resource "kubernetes_config_map" "gnomad_proxy_ips" {
  metadata {
    name = "proxy-ips"
  }
  data = {
    ips = "127.0.0.1,${data.google_compute_subnetwork.gke_vpc.ip_cidr_range},${module.gnomad-gke.gke_pods_ipv4_cidr_block},${module.gnomad-gke.gke_services_ipv4_cidr_block},35.191.0.0/16,130.211.0.0/22${local.static_ip}"
  }
}

# Pre-configures the service account that we use for ES snapshots
resource "kubernetes_service_account" "es_snaps" {
  metadata {
    name = "es-snaps"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.es_snapshots.email
    }
  }
}
