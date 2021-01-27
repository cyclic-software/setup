# Cyclic Setup

All the setup and install steps for Cyclic Software.

## Quick Start

The fastest and easiest way to get up and running is to use [AWS CloudShell](https://console.aws.amazon.com/cloudshell/home). Your user needs cloudformation create permissions to run a template with capabilities named IAM.

Once per user:

```sh
bash <(curl -s https://raw.githubusercontent.com/cyclic-software/setup/main/setup.sh)
```

Once per account:

```sh
bash <(curl -s https://raw.githubusercontent.com/cyclic-software/setup/main/account/bootstrap.sh)
```

If you are running w/o an IAM user, aka with role based access you will need to run the following (per [CodeCommit Docs](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-git-remote-codecommit.html)):

```sh
pip install git-remote-codecommit
```

You will then add repos like:
`git remote add cyclic codecommit::${PROFILE_NAME}@us-east-2://AppRepo`

## Dependencies

- bash compatible shell bash, zsh, etc: `ps -p $$`
- command line tools: `xcode-select --install`
- aws cli version tested on `^2.1.16`
- jq tested on `^1.6`
- aws account with administrative rights
- aws iam user or git-remote-codecommit

Thats all folks.
