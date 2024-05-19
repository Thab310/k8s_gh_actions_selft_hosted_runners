variable "owner" {
  description = "Name of the Engineer that applied terraform"
  type        = string
}

variable "env" {
  description = "Name of the environment"
  type        = string
  default     = "test"
}

//vpc
variable "project" {
  description = "Name of the project"
  type        = string
  default     = "gh-actions-runner"
}

//subnets
variable "pub_sub_az1_cidr_block" {
  description = "CIDR of public subnet in availability 1"
  type        = string
  default     = "11.0.0.0/24"
}

variable "pub_sub_az2_cidr_block" {
  description = "CIDR of public subnet in availability 2"
  type        = string
  default     = "11.0.1.0/24"
}

variable "priv_sub_az1_cidr_block" {
  description = "CIDR of private subnet in availability 1"
  type        = string
  default     = "11.0.2.0/24"
}

variable "priv_sub_az2_cidr_block" {
  description = "CIDR of private subnet in availability 2"
  type        = string
  default     = "11.0.3.0/24"
}

//nodes
variable "capacity_type" {
  description = "Capacity type for the node group"
  type        = string
  default     = "SPOT"
}

variable "instance_types" {
  description = "Ec2 instance types for the worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "scaling_config_desired_size" {
  description = "Scaling configuration desired number of nodes"
  type        = number
  default     = 2
}

variable "scaling_config_max_size" {
  description = "Scaling configuration max number of nodes"
  type        = number
  default     = 5
}

variable "scaling_config_min_size" {
  description = "Scaling configuration min number of nodes"
  type        = number
  default     = 1
}

variable "update_config_max_unavailable" {
  description = "Maximun number of unavailable nodes"
  type        = number
  default     = 1
}