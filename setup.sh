#!/usr/bin/env bash

echo 'Starting setup.sh'

#
## Generate SSH keys
#
if [ ! -f ~/.ssh/id_rsa ]; then
    echo 'Generating public/private ssh keys'
    ssh-keygen -f '~/.ssh/id_rsa' -q -t rsa -b 4096 -C "Cyclic generated ssh public key for codecommit"
fi

#
## Upload public key and config if not already configured.
#
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

#
## Success and next steps.
#
echo 'You are now be configured. To test your ssh config you can run:'
echo ''
echo "ssh git-codecommit.$AWS_DEFAULT_REGION.amazonaws.com"

# git remote add aws-deploy https://git-codecommit.us-east-2.amazonaws.com/v1/repos/$REPO_NAME
