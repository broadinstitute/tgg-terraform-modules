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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gnomad-vpc"></a> [gnomad-vpc](#module\_gnomad-vpc) | github.com/broadinstitute/tgg-terraform-modules//vpc-with-nat-subnet | vpc-with-nat-subnet-v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.dataproc_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.iap_forwarding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dataproc_primary_subnet_range"></a> [dataproc\_primary\_subnet\_range](#input\_dataproc\_primary\_subnet\_range) | The IP address range to use for the primary dataproc subnet | `string` | `"192.168.255.0/24"` | no |
| <a name="input_gke_primary_subnet_range"></a> [gke\_primary\_subnet\_range](#input\_gke\_primary\_subnet\_range) | The IP address range to use for the primary gke subnet | `string` | `"192.168.0.0/20"` | no |
| <a name="input_network_name_prefix"></a> [network\_name\_prefix](#input\_network\_name\_prefix) | The string that should be used to prefix nets, subnets, nats, etc created by this module | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gnomad_vpc_network_name"></a> [gnomad\_vpc\_network\_name](#output\_gnomad\_vpc\_network\_name) | The name of the VPC network created by this module |
| <a name="output_gnomad_vpc_subnet_names"></a> [gnomad\_vpc\_subnet\_names](#output\_gnomad\_vpc\_subnet\_names) | n/a |
<!-- END_TF_DOCS -->

## Misc

### Updating this README

The terraform documentation in this readme is generated with [terraform-docs](https://terraform-docs.io/). If you have modified the terraform code in a way that has added, removed, or changed a variable, resource, or output, you can regenerate the `TF_DOCS` block with:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject .
```
