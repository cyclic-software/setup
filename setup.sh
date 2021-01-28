#!/usr/bin/env bash

echo 'Starting setup.sh'

#
## Install git-comit-remote auth git plugin
#
if command -v pip3 &> /dev/null
then
    pip3 install --quiet --no-input git-remote-codecommit
elif command -v pip &> /dev/null
then
    pip install --quiet --no-input  git-remote-codecommit
else
    echo "nothing matched"
fi

#
## Generate SSH keys
#
if [ ! -f ~/.ssh/id_rsa ]; then
    echo 'Generating public/private ssh keys'
    ssh-keygen -f ~/.ssh/id_rsa -q -t rsa -b 4096 -C "Cyclic generated ssh public key for codecommit"
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
REGION=$(aws configure get region)
PROFILE="\$AWS_PROFILE_NAME"
# # Need to treat blank as unset
# if [ -n "$AWS_PROFILE" ]; then
#   PROFILE="$AWS_PROFILE"
# fi

cat << EOF
You are now be configured. To test your ssh config run:

 % ssh git-codecommit.$REGION.amazonaws.com


You can now add git remotes with ssh keys:

 % git remote add cyclic ssh://git-codecommit.$REGION.amazonaws.com/v1/repos/\$REPO_NAME


You can now add git remotes with AWS profiles (from ~/.aws/credentials):

 % git remote add cyclic codecommit::$REGION://$PROFILE@\$REPO_NAME


EOF


# git remote add cyclic https://git-codecommit.$REGION.amazonaws.com/v1/repos/$REPO_NAME
# git remote add cyclic codecommit::$AWS_DEFAULT_REGION://$AWS_PROFILE_NAME@$REPO_NAME
