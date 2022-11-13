# WIP: tekton-demos

Collection of Tekton demos. 

## Prerequisites  

* [GCP project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
* [gcloud](https://cloud.google.com/sdk/docs/install-sdk)
  * authenticated (`gcloud auth login`)
  * app default configured (`gcloud auth application-default login`)
  * defaults 
    * project (`gcloud config set project YOUR_PROJECT_ID`)
    * region (`gcloud config set compute/region YOUR_GCP_REGION`)
    * zone (`gcloud config set compute/zone YOUR_GCP_ZONE`)
* [terraform](https://developer.hashicorp.com/terraform/downloads)
* [cosign](https://docs.sigstore.dev/cosign/installation/)
* [jq](https://stedolan.github.io/jq/download/)

## Setup 

After the setup, your GCP project will be configured with: 

* 2 Service Accounts (`builder` and `tekton-chains-controller`)
* Kubernetes Cluster (regular channel, workload pool, custom node pool with auto-scaling and auto-repair)
* Artifact Registry 
* KMS ring with crypto key (`tekton-chains-chains-key`)

First, complete a couple **one time setup** steps:

1) Create a GCS bucket (will be used to store the state of the cluster, see [deployments/backends.tf](deployments/backends.tf) for details)
2) Initialize Terraform `terraform -chdir=deployments init`


When done, apply the deployment into your project:

```shell
terraform -chdir=deployments apply
```

## Tekton 

Once you have a GCP project configured, you are ready to install [Tekton](https://tekton.dev). This process will:

* Install Tekton Pipelines and Chains
* Annotate Kubernetes service account to map it to GCP IAM account
* Install Git Clone and Kaniko tasks 
* Configure binary authorization 


```shell
./init-cluster
```

## Demo 

* Config
  * Pipeline ([pipelines/kaniko-pipeline.yaml](pipelines/kaniko-pipeline.yaml))
  * Pipeline Run ([pipelines/demo-pipeline-run.yaml](pipelines/demo-pipeline-run.yaml))
  * Sample app ([hello](https://github.com/mchmarny/hello))
* Run `kubectl create -f pipelines/demo-pipeline-run.yaml` 
  * Observe `tkn pr logs --last -f` (~1 min)
  * Describe `tkn  pipelinerun describe --last`
* Review [registry](https://console.cloud.google.com/artifacts) (hello/hello)
  * OCI Image (`:latest`)
  * Attestation manifest (image sha)
  * Cosign signature (annotations)
* Verify image
  * Attestation (by checking the claims against the transparency log)
    * `./verify_attestation`
  * Provenance (trace build back to source, SLSA v0.2)
    * `./verify_provenance`

## Disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.