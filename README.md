# Kubernetes HA on Google Compute Engine
The repo contains actions and Terraform code to provision 3 control plane nodes in 3 zones, a VPC, a Load Balancer and the required Health checks and firewall rule.


## Used Components and Tools

 * Terraform - for automated resources provisioning in gce
 * GitHub Actions 

## Preparation
### Create GitHub repository

Create new repository on GitHub [manually](https://docs.github.com/en/get-started/quickstart/create-a-repo)
or using [GitHub CLI](https://cli.github.com/manual/gh_repo_create).


### Get your gce credentials
You need a Service Account with the appropriate permissions for Terraform to create the infrastructure.

Use `gcloud` CLI tool to create these credentials.

```bash
export GCLOUD_PROJECT="GCP_PROJECT_ID"
export SERVICE_ACCOUNT_NAME="SAME_AS_SSH_USERNAME" 
# create new service account
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}"
# get your service account id
export SERVICE_ACCOUNT_ID=$(gcloud iam service-accounts list --filter="name:${SERVICE_ACCOUNT_NAME}" --format='value(email)')
# create policy bindings for KKP
gcloud projects add-iam-policy-binding "${GCLOUD_PROJECT}" --member="serviceAccount:${SERVICE_ACCOUNT_ID}" --role='roles/compute.admin'
gcloud projects add-iam-policy-binding "${GCLOUD_PROJECT}" --member="serviceAccount:${SERVICE_ACCOUNT_ID}" --role='roles/iam.serviceAccountUser'
gcloud projects add-iam-policy-binding "${GCLOUD_PROJECT}" --member="serviceAccount:${SERVICE_ACCOUNT_ID}" --role='roles/viewer'
gcloud projects add-iam-policy-binding "${GCLOUD_PROJECT}" --member="serviceAccount:${SERVICE_ACCOUNT_ID}" --role='roles/storage.admin'
# create policy bindings for Google GitHub actions
gcloud iam service-accounts add-iam-policy-binding ${SERVICE_ACCOUNT_ID} --member="serviceAccount:${SERVICE_ACCOUNT_ID}" --role='roles/iam.serviceAccountTokenCreator'
# create a new json key for your service account
gcloud iam service-accounts keys create --iam-account "${SERVICE_ACCOUNT_ID}" "${SERVICE_ACCOUNT_NAME}-sa-key.json"
# export JSON file content of created service account json key
export GOOGLE_CREDENTIALS=$(cat "${SERVICE_ACCOUNT_NAME}-sa-key.json")
```

See [KubeOne documentation](https://docs.kubermatic.com/kubeone/master/architecture/requirements/machine_controller/google_cloud/gcp/) for more details.

### Generate SSH keys

SSH public/private key-pair is used for accessing the master cluster nodes. You can generate these keys locally,
and you will need to set them inside the secret management below.

You can use following command to generate the keys:

```bash
ssh-keygen -t rsa -b 4096 -C ${SERVICE_ACCOUNT_NAME} -f k8s_rsa
```

You will need the content of private/public SSH key in the next steps, pipeline will use it for accessing the nodes.
### Setup GitHub Secrets for the GitHub Workflow pipeline

Go to your GitHub repository under "Settings" -> "Secrets" and setup following secrets:
 * `GOOGLE_CREDENTIALS` with value of your Google Service Account (see above)
 * `SSH_PRIVATE_KEY` with value of private SSH key (e.g. content of `k8s_rsa`)
 * `SSH_PUBLIC_KEY` with value of public SSH key (e.g. content of `k8s_rsa.pub`)

### Push Content to your Git repository

```bash
git init
git checkout -b main
git add .
git commit -m "Initial setup for KKP on Autopilot"
git remote add origin git@github.com:<GITHUB_OWNER>/<GITHUB_REPOSITORY>
git push -u origin main
```

### Validation
Check the steps of the GitHub Actions after first merge to `main` branch and enjoy the full deployment of KKP at the end!

## High-level Pipeline Design

*tf-validate*
* runs validation of all Terraform modules

*tf-prepare*
* prepare Terraform backend for storing state

*tf-plan*
* prepare Terraform plan based on the stored state
* Terraform state is stored on AWS S3 bucket (created in previous step)

*tf-apply*
* applies the Terraform changes based on a plan (from previous stage)
* runs only on `main` branch
==> VMs, network and LB for k8s on AWS is prepared at this stage
