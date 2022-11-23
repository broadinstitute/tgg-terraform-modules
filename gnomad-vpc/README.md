# gnomad-vpc

Creates a shared/reusable VPC configuration to ensure that all the gnomad browser GCP environments have an identical network configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                             | Version   |
| ---------------------------------------------------------------- | --------- |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.44.1 |

## Providers

| Name                                                       | Version   |
| ---------------------------------------------------------- | --------- |
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.44.1 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                      | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [google_compute_firewall.allow_ssh_broad_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)                         | resource    |
| [google_compute_firewall.dataproc_internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)                              | resource    |
| [google_compute_firewall.iap_forwarding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)                                 | resource    |
| [google_compute_network.network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)                                          | resource    |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router)                                             | resource    |
| [google_compute_router_nat.router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat)                                 | resource    |
| [google_compute_subnetwork.dataproc_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)                            | resource    |
| [google_compute_subnetwork.gnomad_subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork)                              | resource    |
| [google_storage_bucket_object_content.internal_networks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/storage_bucket_object_content) | data source |

## Inputs

| Name                                                                                            | Description                                                                               | Type     | Default | Required |
| ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| <a name="input_network_name_prefix"></a> [network\_name\_prefix](#input\_network\_name\_prefix) | The string that should be used to prefix nets, subnets, nats, etc created by this module. | `string` | n/a     |   yes    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
