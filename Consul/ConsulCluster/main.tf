module "consul-starter" {
  source  = "hashicorp/consul-starter/aws"
  version = "0.2.0"
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
  consul_version = var.consul_version
  name_prefix = var.name_prefix
  owner = var.owner

  vpc_id = "vpc-032f63cb8f87d50d3"  //Change this value with the newer one whenever applying the VPC module. 

  consul_clients = var.num_clients
  consul_servers = var.num_servers
  instance_type = var.instance_type
  key_name = var.ssh_key_name
  public_ip = var.should_have_public_ip
}
