module "vpc" {
  source = "../../modules/01-vpc"

  project = var.project
}

module "igw" {
  source = "../../modules/02-igw"

  project = var.project
  vpc_id  = module.vpc.vpc_id
}

data "aws_availability_zones" "azs" {}

module "subnets" {
  source = "../../modules/03-subnets"

  az1                    = data.aws_availability_zones.azs.names[0]
  az2                    = data.aws_availability_zones.azs.names[1]
  vpc_id                 = module.vpc.vpc_id
  public_az1_cidr_block  = var.pub_sub_az1_cidr_block
  public_az2_cidr_block  = var.pub_sub_az2_cidr_block
  private_az1_cidr_block = var.priv_sub_az1_cidr_block
  private_az2_cidr_block = var.priv_sub_az2_cidr_block
  eks_name = local.eks_name
}

module "nat" {
  source = "../../modules/04-nat"

  pub_az1_id = module.subnets.pub_sub_az1_id
  project    = var.project
}

module "routes" {
  source = "../../modules/05-routes"

  project         = var.project
  igw_id          = module.igw.igw_id
  vpc_id          = module.vpc.vpc_id
  nat_gateway_id  = module.nat.nat_gateway_id
  pub_sub_az1_id  = module.subnets.pub_sub_az1_id
  pub_sub_az2_id  = module.subnets.pub_sub_az2_id
  priv_sub_az1_id = module.subnets.priv_sub_az1_id
  priv_sub_az2_id = module.subnets.priv_sub_az2_id
}

module "eks" {
  source = "../../modules/06-eks"

  eks_name        = local.eks_name
  pub_sub_az1_id  = module.subnets.pub_sub_az1_id
  pub_sub_az2_id  = module.subnets.pub_sub_az2_id
  priv_sub_az1_id = module.subnets.priv_sub_az1_id
  priv_sub_az2_id = module.subnets.priv_sub_az2_id

}

module "nodes" {
  source = "../../modules/07-nodes"

  eks_name                      = local.eks_name
  priv_sub_az1_id               = module.subnets.priv_sub_az1_id
  priv_sub_az2_id               = module.subnets.priv_sub_az2_id
  capacity_type                 = var.capacity_type
  instance_types                = var.instance_types
  scaling_config_desired_size   = var.scaling_config_desired_size
  scaling_config_max_size       = var.scaling_config_max_size
  scaling_config_min_size       = var.scaling_config_min_size
  update_config_max_unavailable = var.update_config_max_unavailable
}

data "vault_generic_secret" "github_app_secrets" {
  path = "secret/github-app"
}

module "k8s" {
  source = "../../modules/08-k8s"

  github_app_id              = data.vault_generic_secret.github_app_secrets.data["github_app_id"]
  github_app_installation_id = data.vault_generic_secret.github_app_secrets.data["github_app_installation_id"]
  github_app_private_key     = data.vault_generic_secret.github_app_secrets.data["github_app_private_key"]
}

# module "irsa" {
#   source = "../../modules/09-irsa"

#   eks_name = local.eks_name
# }
module "helm_cert_manager" {
  source = "../../modules/12-cert-manager"
  depends_on = [ module.k8s ]
}


module "helm_actions_runner_controller" {
  source = "../../modules/11-actions-runner-controller"
  depends_on = [ module.helm_cert_manager ]

}

