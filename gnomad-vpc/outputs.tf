output "gnomad_vpc_network_name" {
  value       = module.gnomad-vpc.vpc_network_name
  description = "The name of the VPC network created by this module"
}

output "gnomad_vpc_network_id" {
  value = module.gnomad-vpc.vpc_network_id
}

output "gnomad_vpc_subnet_names" {
  value = module.gnomad-vpc.vpc_subnet_names
}
