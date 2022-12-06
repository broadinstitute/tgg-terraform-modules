variable "project_id" {
  description = "The name of the target GCP project, for creating IAM memberships"
  type        = string
}

variable "infra_prefix" {
  description = "The string to use for a prefix on resource names (GKE cluster, GCS Buckets, Service Accounts, etc)"
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the VPC network that the GKE cluster should reside in"
  type        = string
}

variable "vpc_subnet_name" {
  description = "The name of the VPC network subnet that the GKE cluster nodes should reside in"
  type        = string
}

variable "gke_control_plane_zone" {
  description = "The GCP zone where the GKE control plane will reside"
  type        = string
}

variable "gke_control_plane_cidr_range" {
  description = "The IPv4 CIDR Range that should be used for the GKE control plane"
  type        = string
}

variable "gke_control_plane_authorized_networks" {
  description = "The IPv4 CIDR ranges that should be allowed to connect to the control plane"
  type        = list(string)
  default     = []
}

variable "gke_include_broad_inst_authorized_networks" {
  description = "Include the Broad Institute network ranges in the GKE control plane authorized networks"
  type        = bool
  default     = false
}

variable "gke_cluster_secondary_range_name" {
  description = "The name of the secondary subnet IP range to use for Pods in the GKE cluster"
  type        = string
  default     = "gke-pods"
}

variable "gke_services_secondary_range_name" {
  description = "The name of the secondary subnet IP range to use for GKE services"
  type        = string
  default     = "gke-services"
}

# see https://cloud.google.com/kubernetes-engine/docs/how-to/maintenance-windows-and-exclusions#maintenance-window
# for more information regarding timestamp formatting and recurrence spec syntax
variable "gke_recurring_maint_windows" {
  description = "A start time, end time and recurrence pattern for GKE automated maintenance windows"
  type        = list(map(string))
  default = [{
    start_time = "1970-01-01T07:00:00Z"
    end_time   = "1970-01-01T11:00:00Z"
    recurrence = "FREQ=DAILY"
  }]
}

# see https://cloud.google.com/kubernetes-engine/docs/how-to/maintenance-windows-and-exclusions##configuring_a_maintenance_exclusion
# for more information regarding timestamp formatting
# Example value: [{ start_time = "2021-04-30T19:25:44Z", end_time = "2021-05-04T19:25:44Z", name = "sre-on-vacation" }]
variable "gke_maint_exclusions" {
  description = "Specified times and dates that non-emergency GKE maintenance should pause"
  type        = list(map(string))
  default     = []
}

variable "gke_node_pools" {
  description = "A list of node pools and their configuration that should be created within the GKE cluster; pools with an empty string for the zone will deploy in the same region as the control plane"
  type = list(object({
    pool_name            = string
    pool_num_nodes       = number
    pool_machine_type    = string
    pool_preemptible     = bool
    pool_zone            = string
    pool_resource_labels = map(string)
  }))
  default = [
    {
      "pool_name"            = "main-pool"
      "pool_num_nodes"       = 2
      "pool_machine_type"    = "e2-standard-4"
      "pool_preemptible"     = false
      "pool_zone"            = ""
      "pool_resource_labels" = {}
    },
    {
      "pool_name"         = "redis"
      "pool_num_nodes"    = 1
      "pool_machine_type" = "e2-custom-6-49152"
      "pool_preemptible"  = false
      "pool_zone"         = ""
      "pool_resource_labels" = {
        "component" = "redis"
      }
    },
    {
      "pool_name"         = "es-data"
      "pool_num_nodes"    = 3
      "pool_machine_type" = "e2-highmem-8"
      "pool_preemptible"  = false
      "pool_zone"         = ""
      "pool_resource_labels" = {
        "component" = "elasticsearch"
      }
    }
  ]
}
variable "gke_preemptible_nodes" {
  description = "Whether or not GKE nodes should be deployed as preemptible"
  type        = bool
  default     = false
}

variable "es_snapshots_bucket_location" {
  description = "The GCS location for the elasticsearch snapshots bucket"
  type        = string
  default     = "us-east1"
}

variable "data_pipeline_bucket_location" {
  description = "The GCS location for the data-pipeline bucket"
  type        = string
  default     = "us-east1"
}
