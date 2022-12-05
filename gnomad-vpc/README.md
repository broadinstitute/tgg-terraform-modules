# gnomad-vpc

Creates a shared/reusable VPC configuration to ensure that all the gnomad browser GCP environments have an identical network configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow_ssh_broad_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.dataproc_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.iap_forwarding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.dataproc_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.gnomad_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_storage_bucket_object_content.internal_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_broad_institute_networks"></a> [allow\_broad\_institute\_networks](#input\_allow\_broad\_institute\_networks) | Allow broad's network/ip ranges in various firewall rules | `bool` | `true` | no |
| <a name="input_dataproc_primary_subnet_range"></a> [dataproc\_primary\_subnet\_range](#input\_dataproc\_primary\_subnet\_range) | The IP address range to use for the primary dataproc subnet | `string` | n/a | yes |
| <a name="input_gke_pods_secondary_range"></a> [gke\_pods\_secondary\_range](#input\_gke\_pods\_secondary\_range) | The IP address range to use for the secondary IP address range for GKE Pods | `string` | n/a | yes |
| <a name="input_gke_services_secondary_range"></a> [gke\_services\_secondary\_range](#input\_gke\_services\_secondary\_range) | The IP address range to use for the secondary IP address range for GKE Services | `string` | n/a | yes |
| <a name="input_gnomad_primary_subnet_range"></a> [gnomad\_primary\_subnet\_range](#input\_gnomad\_primary\_subnet\_range) | The IP address range to use for the primary gnomad subnet | `string` | n/a | yes |
| <a name="input_network_name_prefix"></a> [network\_name\_prefix](#input\_network\_name\_prefix) | The string that should be used to prefix nets, subnets, nats, etc created by this module | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gnomad_subnet_secondary_ranges"></a> [gnomad\_subnet\_secondary\_ranges](#output\_gnomad\_subnet\_secondary\_ranges) | The secondary ranges associated with the gnomad subnet |
| <a name="output_gnomad_vpc_network_gke_subnet_name"></a> [gnomad\_vpc\_network\_gke\_subnet\_name](#output\_gnomad\_vpc\_network\_gke\_subnet\_name) | n/a |
| <a name="output_gnomad_vpc_network_name"></a> [gnomad\_vpc\_network\_name](#output\_gnomad\_vpc\_network\_name) | The name of the VPC network created by this module |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a way that has added, removed, or changed a variable, resource, or output, you can regenerate the `TF_DOCS` block with:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
