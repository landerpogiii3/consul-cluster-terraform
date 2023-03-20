variable "aws_region" {
  description = "Preferred AWS Region"
  type = string
  default = "ap-southeast-1"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type = string
  default = "dimacaliSingaporeKeyPair"
}

variable "vpc_name" {
  description = "The name of VPC to be created"
  type = string
  default = "dimacali-vpc"
}

variable "cluster_name" {
  description = "The name of the Consul cluster"
  type = string
  default = "dimacali-Consul-cluster"
}

variable "num_clients" {
  description = "The number of Consul client nodes to deploy. You typically run the Consul client alongside your apps, so set this value to however many Instances make sense for your app code."
  type = number
  default = 6
}

variable "num_servers" {
  description = "The number of Consul server nodes to deploy. We strongly recommend using 3 or 5."
  type = number
  default = 3
}

variable "allowed_inbound_cidrs" {
  description = "List of CIDR blocks to permit inbound Consul access from"
  type = list
  default = ["0.0.0.0/0"]
}

variable "consul_version" {
  description = "The version of Consul to apply to the cluster"
  type = string
  default = "1.15.1"
}

variable "name_prefix" {
  description = "The prefix used in resource names"
  type = string
  default = "dimacali"
}

variable "owner" {
  description = "Value of owner tag on EC2 instances"
  type = string
  default = "133353854791"
}

variable "should_have_public_ip" {
  description = "Should ec2 instance have public ip?"
  type = bool
  default = true
}

variable "instance_type" {
  description = "EC2 Instance types"
  type = string
  default = "t3.medium"
}