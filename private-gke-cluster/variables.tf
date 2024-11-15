variable "gke_cluster_name" {
  description = "The name of the GKE cluster you want to manage"
  type        = string
}

variable "project_name" {
  description = "The name of the gcp project the cluster is launching in"
  type        = string
}

variable "gke_control_plane_zone" {
  description = "The zone to launch the GKE cluster in"
  type        = string
  default     = "us-central1-c"
}

variable "gke_master_ipv4_cidr_block" {
  description = "The IPv4 CIDR Range (RFC1918) that should be used for the control plane"
  type        = string
  default     = "172.16.0.0/28"
}

variable "gke_services_range_slice" {
  description = "The CIDR notation for the size of the GKE services IP address alias range"
  type        = string
  default     = "/20"
}

variable "gke_pods_range_slice" {
  description = "The CIDR notation for the size of the GKE pods IP address alias range"
  type        = string
  default     = "/14"
}

variable "resource_labels" {
  description = "A map of string values to use as resource labels on all cluster objects."
  type        = map(string)
  default     = {}
}

variable "vpc_network_name" {
  description = "The name of the VPC network to launch the cluster in"
  type        = string
  default     = "default"
}

variable "vpc_subnet_name" {
  description = "The name of the VPC network subnet to launch the cluster in"
  type        = string
  default     = "default"
}

variable "release_channel" {
  description = "The release channel name for the GKE cluster"
  type        = string
  default     = "STABLE"
}

variable "node_pools" {
  description = "A list of node pools and their configuration that should be created within the GKE cluster; pools with an empty string for the zone will deploy in the same region as the control plane"
  type = list(object({
    pool_name            = string
    pool_num_nodes       = optional(number, 2)
    pool_machine_type    = optional(string, "e2-medium")
    pool_preemptible     = optional(bool, false)
    pool_spot            = optional(bool, true)
    pool_zone            = optional(string, "")
    pool_resource_labels = optional(map(string), {})
    pool_taints          = optional(list(object({ key = string, value = string, effect = string })), [])
    pool_autoscaling     = optional(object({ min_pool_nodes = string, max_pool_nodes = string }))
  }))
  default = [
    {
      "pool_name"            = "main-pool"
      "pool_num_nodes"       = 2
      "pool_machine_type"    = "e2-medium"
      "pool_preemptible"     = true
      "pool_spot"            = false
      "pool_zone"            = ""
      "pool_resource_labels" = {}
      "pool_taints"          = []
    }
  ]
}

variable "gke_control_plane_authorized_networks" {
  description = "The IPv4 CIDR ranges that should be allowed to connect to the control plane"
  type        = list(string)
  default     = []
}

# GKE Maintenance windows
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

variable "deletion_protection" {
  description = "Whether or not to enable deletion protection on the GKE cluster. Default false."
  type        = bool
  default     = false
}

# see: https://cloud.google.com/kubernetes-engine/docs/how-to/disable-kubelet-readonly-port
variable "enable_insecure_kubelet_port" {
  description = "Disables the unauthenticated readonly kubelet port"
  type        = string
  default     = "FALSE"
  validation {
    condition     = contains(["TRUE", "FALSE"], var.enable_insecure_kubelet_port)
    error_message = "The value provided must be a string matching either TRUE or FALSE"
  }
}

variable "enable_dns_endpoint_config" {
  description = "Disables or Enables the DNS endpoint for the GKE control plane"
  type        = bool
  default     = false
}

variable "enable_private_only_ip_endpoint" {
  description = "Disables or Enabels the public IP address on your GKE control plane"
  type        = bool
  default     = false
}

variable "enable_secrets_manager" {
  description = "Enables or disables the secrets manager add-on for mounting Google Secret Manager secrets as volumes"
  type        = bool
  default     = false
}
