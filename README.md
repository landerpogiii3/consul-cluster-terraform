# consul-cluster-terraform
This repo contains integration terraform modules that spins up Consul cluster on AWS through terraform.
There are numerous publicly available terraform modules on its registry, however, some of them are deprecated or some of them only spin up clusters without configuration. This document used a module that spins up EC2 instances that will be used to form the EC2 clusters. Additionally, this module is based on the Consul Recommended Architecture as shown below:

## VPC ##

For simplicity, only 2 subnets were created in the VPC.
This architecture deploys 5 nodes within the Consul cluster distributed between 3 availability zones as this architecture can withstand the loss of two nodes from within the cluster or the loss of an entire availability zone. However, since only 2 subnets were configured, the architecture is scaled in.

More information about the Terraform Consul-Starter Module [here](https://registry.terraform.io/modules/hashicorp/consul-starter/aws/latest "Google's Homepage")

The servers and clients together form a single Consul cluster. The only difference between servers and clients is that servers are the only components that store and replicate data. Members of a Consul cluster automatically discover each other as long as they are given the address of at least one existing member.

## Key-Pair ##

I used my Key-Pair module that consistently updates my Key-Pair. This module is placed in Github. When called out, it creates a .pem file in the root of the terraform code and if the file already exists, it updates the public key information. Instead of assigning the pem file with 400 permissions, I have assigned it 600 so that when the module runs, it is writable. This may not be a good practice but, this works for my development environment.

The use of this module is so that I can access the EC2 instances that will form the cluster. 

Note: The VPC and Key-Pair modules are placed in one terraform directory. This means that when applied, both modules will be assessed and applied in AWS. However, the Consul terraform code has its separate folder because of provider version issues (hashicorp/aws). It is also why the VPC module has an output that displays its vpc_id value.

## Consul Cluster ##

As previously mentioned, this module is separated from the VPC folder. It is important to note that when applying both codes, the VPC and Key-Pair folder (both in 1 folder, referred to as VPC folder), must be successfully applied first. This is because the Consul module requires an input for the VPC ID which can be referred to when the VPC folder has been successfully applied. 

This may be an inconvenience but because of versioning issues, all of the modules cannot be contained in 1 terraform folder.

## Inputs Description ##

**allowed_inbound_cidrs**:	Similar to EKS cluster, this is set to 0.0.0.0/0 value for ease of access in development environment. But for production, this must be set to the Public IP leased and used by the organization. 

**consul_version**:		The version of Consul 

**name_prefix**:		The prefix used in resource names. For tracking and management, I have set this to ”dimacali” 

**owner**:			The value of the owner tag on EC2 instances. This is set to the role I am currently using. 

**vpc_id**:			This value constantly changes as previously mentioned. This is the ID of the VPC that the other module creates and generates. 

**consul_clients**:		The number of consul clients. For dev environment, this is set to 2 

**consul_servers**:		The number of consul servers. For dev environment, this is set to 4 

**instance_type**:		The instance type I selected is based on the recommendation from the Recommended Consul Architecture which is m5.large

**key_name**:			This will be the name of my SSH key. I have set this to dimacaliSingaporeKeyPair. Note that this must also be consistent with the Key-Pair module.

**public_ip**:			Whether the EC2 instances should have public IP. This is set to true so that I can SSH into the instances directly.

When applied, this will create consul_clients number of Consul Clients and consul_servers number of Consul Servers. To configure the cluster, Servers and Clients must be configured accordingly. This can be done using user_data input but for some reason, I’m having difficulty bootstrapping the commands with my config. For now, I configured the cluster manually through SSH. The commands are documented in a sh file though. 

The cluster was configured this way:

## Server ##

The consul was installed through the following commands: 

Add the HashiCorp GPG key 

    curl --fail --silent --show-error –location https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/hashicorp-archive-keyring.gpg 

Add the official HashiCorp Linux repository. 

    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/hashicorp.list 

Update 

    sudo apt update 


Install the latest version of Consul. Use –y to automatically respond yes to prompts 

    sudo apt install consul -y 

Verify the installation 

    consul –v

To run consul, execute the command: 

    consul agent –dev –client=0.0.0.0 -bind 10.0.4.98 

This should not let you use the current prompt. If an error occurs, troubleshoot accordingly. 

This command will let you access the Web GUI of the consul server. To access the consul server, use this convention: [Public IPv4 DNS | Public IPv4 address]:8500 

example: ec2-18-142-255-157.ap-southeast-1.compute.amazonaws.com:8500

## Client ##

To add clients to the cluster, execute the following commands: 

Install consul the same way you installed it on the server. Stop when the consul –v command is satisfied. 

Add clients by executing: 

    consul agent –join [consul-server private IP address] 

example:	consul agent –join 10.0.4.98 --data-dir /tmp/consul 

This should not let you use the current prompt. If an error occurs, troubleshoot accordingly. 

Once successful, refresh the Webpage of the consul server and navigate to *Nodes*