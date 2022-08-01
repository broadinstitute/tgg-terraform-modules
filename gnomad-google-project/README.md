# gnomAD Terraform Project

This module is designed to easily spin up a google cloud project in a configuration that is suitable for typical gnomAD activities.

Namely:

- Create a google project with a randomized suffix (this makes the project easier to delete and recreate if necessary)
- Enable frequently used APIs/Services:
  - Dataproc API
  - Cloudfunctions API
  - Storage API (if necessary)
- Create a VPC network to run resources in
- Add some default firewall rules to allow for traffic in our commonly used service scenarios
- Set a specified group as the owner of the project
- Create a service account for dataproc to run as
- A firewall rule allowing SSH access to the networks from Broad IP ranges

