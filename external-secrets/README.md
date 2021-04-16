# External Secrets

This module configures the necessary GCP resources for running external-secrets. To use this module, you need to pass in an application name and an environment name to help describe what you'll be running external-secrets in.

```terraform
module "webappname-external-secrets" {
    env      = "staging"
    app_name = "webappname"
    source   = git@github.com:broadinstitute/tgg-terraform-modules.git//external-secrets?ref=v0.0.1
}
```
