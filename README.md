# consul-cluster-terraform
This repo contains integration terraform modules that spins up Consul cluster on AWS through terraform.
There are numerous publicly available terraform modules on its registry, however, some of them are deprecated or some of them only spin up clusters without configuration. This document used a module that spins up EC2 instances that will be used to form the EC2 clusters. Additionally, this module is based on the Consul Recommended Architecture as shown below:

**VPC**

For simplicity, only 2 subnets were created in the VPC.
This architecture deploys 5 nodes within the Consul cluster distributed between 3 availability zones as this architecture can withstand the loss of two nodes from within the cluster or the loss of an entire availability zone. However, since only 2 subnets were configured, the architecture is scaled in.

More information about the Terraform Consul-Starter Module [I'm an inline-style link with title](https://www.google.com "Google's Homepage")