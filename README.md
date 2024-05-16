# Github actions self hosted runners running on k8s
## Architecture
![architecture](/images/Untitled-2023-03-01-2339.png)
## Prerequisites
* vs-code
* aws cli
* terraform
* hashicorp vault
* Golang
* docker
* kubectl
## AWS Providers
## Kubernetes Providers
## Kubectl Providers
## TLS Providers
## Helm Providers
1. ``cert-manager``
  -  cert-manager is a Kubernetes add-on that automates the process of obtaining, renewing, and using TLS certificates within Kubernetes clusters. It integrates with various certificate authorities (e.g., Let's Encrypt, Vault) and can automatically provision and manage certificates for Kubernetes resources like Ingress, Services, and custom resources, ensuring secure encrypted communication without manual intervention.


2. ``actions-runner-controller``
- An Actions runner controller is a Kubernetes component that manages self-hosted runners for GitHub Actions within a Kubernetes cluster. It automates the deployment, scaling, lifecycle management, security, and monitoring of self-hosted runners as Kubernetes Pods. This allows you to leverage the capabilities of Kubernetes for your GitHub Actions workflows while still using self-hosted runners.
> note: Actions-runner-controller uses cert-manager for certificate management of Admission webhook
## Runners
There are 2 types of runners with Github actions
1. Github-hosted runners
2. Selft-hosted runners

## Authenticating with Github API

There are 2 ways for actions-runner-controller to authenticate with the Github API (only 1 can be configured at a time however:)
1. Using a Github app (Increased API quota)
2. Using a PAT 

## Getting started

Clone the repo vis SSH or HTTPS
  ```bash
  #SSH
  git clone git@github.com:Thab310/k8s_gh_actions_selft_hosted_runners.git

  #HTTPS
  git clone https://github.com/Thab310/k8s_gh_actions_selft_hosted_runners.git

  ````

### 1. Create a Github app authentication

 Make sure to disable webhooks because we don't want to expose our actions controller outside to the internet (By default autoscaling We will be using a long http poll)


Repository permissions

* Set admin read-write access permissions

* Set Actions read-only access permissions

Generate private key for the app (which will automatically install the private key on your machine) 

:warning: **Caution:** make sure to not save the key in your git repository because you definately don't want to push the key to github.

Install the app for the k8s runner repo.


### 2. Create Hashicorp vault secrets
run:
```bash
vault server -dev
```

Copy & Paste these commad on another bash terminal
```bash
  $ export VAULT_ADDR='http://127.0.0.1:8200'
  $ export VAULT_TOKEN='<Root-Token>'
```

To verify status of vault server run:
```bash
vault status
```
Add secrets in vault:
```bash
vault kv put secret/github-app \
  github_app_id="your_github_app_id" \
  github_app_installation_id="your_github_app_installation_id" \
  github_app_private_key="-----BEGIN PRIVATE KEY-----\n...your_private_key...\n-----END PRIVATE KEY-----"
```
* github_app_id : you will find it on the github app homepage
* github_app_installation_id : you will find iit on the url of install github app

### 3. Test Terraform code 

### 4. Create terraform resources
cd into `terraform/environment/dev` and create `terraform.tfvars` file, assign the necessary variable values from the `variables.tf` file

Run terraform:
```bash
Terraform init
Terraform plan
Terraform apply -auto-approve 
```

### 5. link local kubectl to EKS

In a normal scenario we would need to run the command below to 
Verify eks cluster, but we will not runner this because the kubectl provider in terraform has done the heavy lifting for us, saving us time as devops/sre/platform engineers:
```bash
aws eks update-kubeconfig --name <eks-cluster-name> --region <aws-region>
```
