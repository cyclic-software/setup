#!/usr/bin/env bash

set -eux

echo 'Starting setup.sh'

# aws iam create-service-specific-credential --user-name (aws iam get-user | jq -r '.User.UserName') --service-name codecommit.amazonaws.com

# git remote add aws-deploy https://git-codecommit.us-east-2.amazonaws.com/v1/repos/$REPO_NAME

ls -lart ~/.ssh/
set +e
grep -q 'git-codecommit.*.amazonaws.com' ~/.ssh/config
if [[ $? > 0 ]]; then
    echo "No codecommit ssh key configured"

    key_id=$(
    aws iam upload-ssh-public-key \
        --user-name $(aws iam get-user | jq -r '.User.UserName') \
        --ssh-public-key-body file://~/.ssh/id_rsa.pub \
    | jq -r '.SSHPublicKey.SSHPublicKeyId')

    # Prepend the gitcommit ssh key info to
    cp ~/.ssh/config ~/.ssh/config_pre_cyclic_install_$(date +%Y%m%d)
cat > ~/.ssh/config << EOF
Host git-codecommit.*.amazonaws.com
  User $key_id
  IdentityFile ~/.ssh/id_rsa
EOF
    cat ~/.ssh/config_pre_cyclic_install_$(date +%Y%m%d) >> ~/.ssh/config

fi
