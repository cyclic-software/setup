# Cyclic Setup

All the setup and install steps for Cyclic Software.

## Quick Start

The fastest and easiest way to get up and running is to use [AWS CloudShell](https://console.aws.amazon.com/cloudshell/home). Your user needs cloudformation create permissions to run a template with capabilities named IAM.

Once per user:
```
bash <(curl -s https://raw.githubusercontent.com/cyclic-software/setup/main/setup.sh)
```

Once per account:
```
bash <(curl -s https://raw.githubusercontent.com/cyclic-software/setup/main/account/bootstrap.sh)
```

## Dependencies

- bash compatible shell bash, zsh, etc: `ps -p $$`
- command line tools: `xcode-select --install`
- aws cli version tested on `^2.1.16`
- jq tested on `^1.6`
- aws sam configured in your account

Thats all folks.
