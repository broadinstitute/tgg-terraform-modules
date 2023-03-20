# include GKE cluster

module "atlantis-gke" {
  source           = "github.com/broadinstitute/tgg-terraform-modules//private-gke-cluster?ref=4e2943c925ac00c95d247a5502356d616add83e4"
  gke_cluster_name = "tgg-atlantis"
  project_name     = "tgg-automation"
  resource_labels = {
    "terraform"  = "true"
    "deployment" = "atlantis"
    "component"  = "gke"
  }
  vpc_network_name = var.vpc_network_name
  vpc_subnet_name  = var.vpc_subnet_name
}

# atlantis service account
resource "google_service_account" "atlantis_runner" {
  account_id   = "tgg-atlantis-runner"
  display_name = "TGG Atlantis Runner"
}

# static IP, tls cert etc
resource "google_compute_global_address" "atlantis_ip" {
  name = "tgg-atlantis"
}
