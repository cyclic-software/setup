#!/usr/bin/env bash

set -eux

echo 'Starting setup.sh'

# aws iam create-service-specific-credential --user-name (aws iam get-user | jq -r '.User.UserName') --service-name codecommit.amazonaws.com

# git remote add aws-deploy https://git-codecommit.us-east-2.amazonaws.com/v1/repos/$REPO_NAME
