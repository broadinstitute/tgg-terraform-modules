variable "app_name" {
  type = string
  description = "The name of the application or environment where we are being deployed. E.g. {clingen,seqr,gnomad}"
}

variable "env" {
  type        = string
  description = "The name of the environment we are deploying to. E.g. {dev,stage,prod}"
}
