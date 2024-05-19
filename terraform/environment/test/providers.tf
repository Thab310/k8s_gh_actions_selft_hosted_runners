terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14"
    }
  }
}

#Configure the AWS provider
provider "aws" {
  region = local.region

  default_tags {
    tags = {
      project     = var.project
      environment = var.env
      owner       = var.owner
      terraform   = true
    }
  }
}

#Configure the Helm provider
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_cert)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.eks_name]
      command     = "aws"
    }
  }
}

#Configure the k8s provider
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_cert)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.eks_name]
    command     = "aws"
  }
}

#Configure the Hashicorp Vault provider
provider "vault" {
  // No need to specify VAULT_ADDR or VAULT_TOKEN here because we already ran them manually
}

#Configure kubectl provider
provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_cert)
  load_config_file = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.eks_name]
    command     = "aws"
  }
}

