# tekton-demos

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

> The cluster initialization is based on the work done by [@bendory](https://github.com/bendory/tekton-on-gcp).

Once you have a GCP project configured, you are ready to install [Tekton](https://tekton.dev). This process will:

* Install Tekton Pipelines and Chains
* Annotate Kubernetes service account to map it to GCP IAM account
* Install Git Clone, Snyk scan, and Kaniko tasks ([Tekton Hub](https://hub.tekton.dev/))
* Configure binary authorization 


```shell
./init-cluster
```

> Fo info how to export the entire configuration into Terraform see [deployments/README.md](deployments/README.md).

## Demo 

* Config
  * Pipeline ([pipelines/demo-pipeline.yaml](pipelines/demo-pipeline.yaml))
  * Pipeline Run ([pipelines/demo-pipeline-run.yaml](pipelines/demo-pipeline-run.yaml))
  * [Tekton Hub](https://hub.tekton.dev/)
  * Sample app ([hello](https://github.com/mchmarny/hello))
* Run `kubectl create -f pipelines/demo-pipeline-run.yaml` 
  * Observe `tkn pr logs --last -f` (~1 min)
  * Describe `tkn  pipelinerun describe --last`
* Review [registry](https://console.cloud.google.com/artifacts) (hello/hello)
  * OCI Image (`:latest`)
  * Attestation manifest (image sha)
  * Cosign signature (annotations)
* Verify image
  * Attestation (check the claims against transparency log)
    * `./verify_attestation`
  * Provenance (trace build back to source, [SLSA v0.2](https://slsa.dev/provenance/v0.2))
    * `./verify_provenance`

## TODO

* Rekor query (https://rekor.tlog.dev/)
* VEX example (https://www.cisa.gov/sites/default/files/publications/VEX_Use_Cases_Aprill2022.pdf, https://github.com/CycloneDX/bom-examples/blob/master/VEX/vex.json)


## Disclaimer

This is my personal project and it does not represent my employer. While I do my best to ensure that everything works, I take no responsibility for issues caused by this code.
