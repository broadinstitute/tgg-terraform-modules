# imported GKE cluster module

This module is intended for cases where you have created the GKE cluster in the cloud console, and want to start managing it with terraform. Inputs for this module are the bare minimum to import a GKE cluster with a default node pool, without making terraform think that it needs to replace the cluster.
