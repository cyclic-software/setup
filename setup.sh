#!/usr/bin/env bash

set -ux

echo 'Starting setup.sh'

# aws iam create-service-specific-credential --user-name (aws iam get-user | jq -r '.User.UserName') --service-name codecommit.amazonaws.com

# git remote add aws-deploy https://git-codecommit.us-east-2.amazonaws.com/v1/repos/$REPO_NAME

ls -lart ~/.ssh/

if [ ! -f ~/.ssh/id_rsa ]; then
    echo 'Generating public/private ssh keys'
    ssh-keygen -f '~/.ssh/id_rsa' -q -t rsa -b 4096 -C "Cyclic generated ssh public key for codecommit"
fi

# eval "$(ssh-agent -s)"

# cat >> ~/.ssh/config <<'EOF'
# Host *
#  AddKeysToAgent yes
#  UseKeychain yes
#  IdentityFile ~/.ssh/id_rsa
# EOF

# ssh-add -K ~/.ssh/id_rsa

grep -q 'git-codecommit.*.amazonaws.com' ~/.ssh/config
if [[ $? > 0 ]]; then
    echo 'No codecommit ssh key configured. Uploading.'

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
    chmod 600 ~/.ssh/config
fi

echo 'You are now be configured. To test your ssh config you can run:'
echo ''
echo ' ssh git-codecommit.$AWS_DEFAULT_REGION.amazonaws.com'
