# Welcome to your new GCP project!

This GCP project is provided to you as a space for you to work on your collaborative activities with the gnomAD project. This project is budget capped at an amount agreed upon between you and the gnomAD team. When you reach the budget threshold, ephemeral compute resources within the project are shut down.

- Objects in storage buckets are retained
- Disks attached to VMs are retained, but VMs are stopped
- Data stored on ephemeral disks attached to compute instances may be lost.

If you reach your budget threshold, reach out to us, and we can re-enable the project and adjust your budget for that month. You can receive alerts of your spending in the following slack channel: `#your_budget_channel`

It comes pre-configured with a few things to aid activities that are typical for working with gnomAD:

- The compute engine, dataproc, and google cloud storage APIs are enabled

- A VPC network called `<network-name>` is created so that VMs and dataproc clusters may be launched
	- When launching VMs or Dataproc clusters, you should specify the network name:
		- `hailctl dataproc start my-cluster --network=network-name, --tags=dataproc-node,ssh-broad`
		- `gcloud dataproc cluster create my-cluster --network=network-name, --tags=dataproc-node,ssh-broad`

- Firewall rules that allow dataproc nodes to communicate with eachother is created.
	- When launching dataproc clusters, you should tag the cluster with the `dataproc-node` tag

- Firewall rules that allow connecting to instances / clusters from the Broad VPN
	- When launching instances / clusters, tag them with the `ssh-broad` tag if you'd like to be able to log into the cluster using SSH, from Broad networks.

- A firewall rule to allow SSH access from the GCP Console.

- Two GCS buckets
	- `<projec-name>-storage`: A general use bucket that you can write data into
	- `<project-name>-tmp-4day`: A scratch space bucket which automatically deletes data that is older than 4 days. Use this for storing temporary files that you don't intend to keep.

Your default compute service account is: foobar@developer.googleapis.com. When you need to grant your VMs and clusters access to data and other resources, this is the service account that will need to be granted access.

The gnomAD production team has administrative access to your GCP project. If you need to grant anyone else access to the project, please don't hesitate to reach out.
