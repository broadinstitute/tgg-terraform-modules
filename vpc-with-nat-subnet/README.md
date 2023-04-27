# VPC with NATed subnet

The intention of this module is to configure a subnet with a NAT gateway, which is suitable for running GCE instances that aren't on the public internet. This is a pattern that I imagine I'm going to need elsewhere, so I figured it was best to abstract it out, rather than using the gnomad-specific network config in the gnomad-vpc module.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name that should be given to the VPC network | `string` | `"atlantis"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnet definitions that you'd like to create for the network | <pre>list(object({<br>    subnet_name_suffix           = string<br>    subnet_region                = string<br>    ip_cidr_range                = string<br>    enable_private_google_access = bool<br>    subnet_flow_logs             = bool<br>    subnet_flow_logs_sampling    = string<br>    subnet_flow_logs_metadata    = string<br>    subnet_flow_logs_filter      = string<br>  }))</pre> | <pre>[<br>  {<br>    "enable_private_google_access": true,<br>    "ip_cidr_range": "192.168.0.0/20",<br>    "subnet_flow_logs": false,<br>    "subnet_flow_logs_filter": "true",<br>    "subnet_flow_logs_metadata": "EXCLUDE_ALL_METADATA",<br>    "subnet_flow_logs_sampling": "0.5",<br>    "subnet_name_suffix": "gke",<br>    "subnet_region": "us-central1"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_network_name"></a> [vpc\_network\_name](#output\_vpc\_network\_name) | n/a |
| <a name="output_vpc_subnet_names"></a> [vpc\_subnet\_names](#output\_vpc\_subnet\_names) | n/a |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a wa>

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
