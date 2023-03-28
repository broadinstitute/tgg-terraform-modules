# SSH Firewall Rules

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
| <a name="input_enable_google_private_access"></a> [enable\_google\_private\_access](#input\_enable\_google\_private\_access) | Whether to enable private network access for google services in the primary subnet | `bool` | `true` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name that should be given to the VPC network | `string` | `"atlantis"` | no |
| <a name="input_primary_subnet_cidr"></a> [primary\_subnet\_cidr](#input\_primary\_subnet\_cidr) | The RFC1918 CIDR mask for the primary subnet range | `string` | `"192.168.0.0/20"` | no |
| <a name="input_secondary_network_ranges"></a> [secondary\_network\_ranges](#input\_secondary\_network\_ranges) | A list of network range objects | <pre>list(object({<br>    range_name    = string<br>    ip_cidr_range = string<br>  }))</pre> | <pre>[<br>  {<br>    "ip_cidr_range": "10.0.32.0/20",<br>    "range_name": "gke-services"<br>  },<br>  {<br>    "ip_cidr_range": "10.4.0.0/14",<br>    "range_name": "gke-pods"<br>  }<br>]</pre> | no |
| <a name="input_subnet_name_suffix"></a> [subnet\_name\_suffix](#input\_subnet\_name\_suffix) | The suffix for the name of the primary subnet; resulting name is network\_name-subnet\_name\_suffix | `string` | `"gke"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_network_name"></a> [vpc\_network\_name](#output\_vpc\_network\_name) | n/a |
| <a name="output_vpc_subnet_name"></a> [vpc\_subnet\_name](#output\_vpc\_subnet\_name) | n/a |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a wa>

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
