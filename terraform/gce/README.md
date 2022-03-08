# GCE Quickstart Terraform configs

The GCE Quickstart Terraform configs can be used to create the needed
infrastructure for a Kubernetes HA cluster. Check out the
[Creating Infrastructure guide][docs-infrastructure] to learn more about how to
use the configs and how to provision a Kubernetes cluster using KubeOne.

[docs-infrastructure]: https://docs.kubermatic.com/kubeone/master/guides/using_terraform_configs/

## Inputs
Name	Description	Type	Default	Required
cluster_name	Name of the cluster	string	n/a	yes
cluster_network_cidr	Cluster network subnet cidr	string	"10.240.0.0/24"	no
control_plane_image_family	Image family to use for provisioning instances	string	"ubuntu-1804-lts"	no
control_plane_image_project	Project of the image to use for provisioning instances	string	"ubuntu-os-cloud"	no
control_plane_target_pool_members_count		string	"3"	no
control_plane_type	GCE instance type	string	"n1-standard-2"	no
control_plane_volume_size	Size of the boot volume, in GB	string	"100"	no
project	Project to be used for all resources	string	n/a	yes
region	GCP region to speak to	string	"europe-west3"	no
ssh_agent_socket	SSH Agent socket, default to grab from $SSH_AUTH_SOCK	string	"env:SSH_AUTH_SOCK"	no
ssh_port	SSH port to be used to provision instances	string	"22"	no
ssh_private_key_file	SSH private key file used to access instances	string	""	no
ssh_public_key_file	SSH public key file	string	"~/.ssh/id_rsa.pub"	no
ssh_username	SSH user, used only in output	string	"root"	no
worker_os	OS to run on worker machines	string	"ubuntu"	no
workers_type	GCE instance type	string	"n1-standard-2"	no


## Outputs

| Name | Description |
|------|-------------|
| kubeone\_api | kube-apiserver LB endpoint |
| kubeone\_hosts | Control plane endpoints to SSH to |
| kubeone\_workers | Workers definitions, that will be transformed into MachineDeployment object |
