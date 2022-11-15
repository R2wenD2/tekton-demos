# Terraform 

## Export 

Make sure you have the config connector component installed in `gcloud`:

```shell
gcloud components install config-connector
```

Export all project configuration as terraform configuration into stdout: 

```shell
gcloud beta resource-config bulk-export \
  --project=$PROJECT_ID \
  --resource-format=terraform
```

Or, find the right resource type:

```shell
gcloud beta resource-config list-resource-types
```

And output only that resource type (e.g. GKE Container Cluster and VMs) into `./clusters` directory: 

```shell
gcloud beta resource-config bulk-export \
    --path=./clusters \
    --resource-types=ContainerCluster,ComputeInstance \
    --project=$PROJECT_ID \
    --resource-format=terraform
```