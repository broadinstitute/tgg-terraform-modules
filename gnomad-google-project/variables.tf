variable "project_id" {
  type        = string
  description = "The string that should be used to create the unique ID google project; Will be suffixed with a random identifier"

  validation {
    condition     = length(var.project_id) >= 3 && length(var.project_id) <= 26
    error_message = "The project ID must be longer than 6 characters, and less than 30 characters. Thus, the id you provide here must be longer than 3 characters, and less than or equal to 26 chars to accommodate the randomized identifier."
  }
}

variable "project_name" {
  type        = string
  description = "The human readable name of the project. Does not need to be unique."
}

variable "apis_to_enable" {
  type        = list(string)
  description = "The list of additional APIs to enable. We always enable dataproc and cloudfunctions"
  default     = []
}

variable "enable_default_services" {
  type        = bool
  description = "Whether or not to enable the default cloudfunction or dataproc services. Set to false if you don't want to enable these, or if you want to manage them via apis_to_enable."
  default     = true
}

variable "gcp_folder_id" {
  type        = string
  description = "The ID numder of the GCP Organization folder to place the project in."
}

variable "billing_account_id" {
  type        = string
  description = "The ID of the billing account that the project should be associated with."

}

variable "owner_group_id" {
  type        = string
  description = "The email address for the group you would like to grant Owner access on the project."
}

variable "allow_broad_inst_ssh_access" {
  type        = bool
  description = "Whether to create a firewall rule that allows access to TCP port 22 from Broad Institute networks"
  default     = true
}

variable "configure_dataproc_firewall_rules" {
  type        = bool
  description = "Whether we should configure firewall rules to allow all traffic between nodes tagged 'dataproc-node'. If you intend to use dataproc, you will need this."
  default     = true
}
