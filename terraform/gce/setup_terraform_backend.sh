#!/bin/sh

set -euo pipefail

readonly GENERATED_BUCKET_SUFFIX="z1v35d6oohyp"
readonly TF_STATE_BUCKET_NAME="tf-state-kkp-$GENERATED_BUCKET_SUFFIX"

echo "Setting up GCS bucket ${TF_STATE_BUCKET_NAME} for storing Terraform state."

set -x

# Create the bucket
gsutil mb \
  -l europe-west3 \
  -c "standard" \
  "gs://${TF_STATE_BUCKET_NAME}"

# Enable versioning
gsutil versioning set on "gs://${TF_STATE_BUCKET_NAME}"

# Disable public access
gsutil pap set enforced "gs://${TF_STATE_BUCKET_NAME}"

set +x

printf "Terraform state bucket name: %s\n" "${TF_STATE_BUCKET_NAME}"

# put empty file in bucket for readiness check in pipeline
temp_file=$(mktemp)
gsutil cp $temp_file gs://${TF_STATE_BUCKET_NAME}/bucket-ready
rm -f $temp_file
