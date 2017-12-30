#! /bin/bash

APP="scooter"
GIT_HASH=$(git rev-parse HEAD)

# Write current plan
terraform plan --out $GIT_HASH.plan -state $GIT_HASH.tfstate
echo "Saving ${GIT_HASH}.tfstate to local filesystem..."

# Copy plan to Digital Ocean Storage

# Apply the versioned plan
terraform apply $GIT_HASH.plan