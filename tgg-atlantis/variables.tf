variable "vpc_network_name" {
  description = "The name of the VPC network to deploy atlantis in"
  type        = string
  default     = "atlantis"
}

variable "vpc_subnet_name" {
  description = "The name of the VPC network subnet to deploy atlantis in"
  type        = string
  default     = "atlantis"
}
