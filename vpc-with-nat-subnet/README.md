# SSH Firewall Rules

The intention of this module is to configure a subnet with a NAT gateway, which is suitable for running GCE instances that aren't on the public internet. This is a pattern that I imagine I'm going to need elsewhere, so I figured it was best to abstract it out, rather than using the gnomad-specific network config in the gnomad-vpc module.

## Inputs
