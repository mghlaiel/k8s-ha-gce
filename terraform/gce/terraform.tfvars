cluster_name              = "creometry-edge"
region                    = "europe-west3"
project                   = "kubermatic-342821"
ssh_public_key_file       = "~/.ssh/k8s_rsa.pub"
ssh_username              = "kubermatic"
worker_os                 = "ubuntu"
workers_type              = "n1-standard-2"
control_plane_volume_size = 100
# keep in mind that this value should be set to 1 on initial run (due to how LBs work on GCP)
control_plane_target_pool_members_count = 3
control_plane_type                      = "n1-standard-2"
# initial count of workers in each availability zone
initial_machinedeployment_replicas = 1
# More variables can be overridden here, see variables.tf.
