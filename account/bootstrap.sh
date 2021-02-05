#!/usr/bin/env bash
set -ex

aws --version

temp_template=$(date +bootstrap-%Y%m%d-%H%M%S.yaml)

curl -s https://raw.githubusercontent.com/cyclic-software/setup/main/account/bootstrap.yaml >$temp_template

aws cloudformation create-stack \
	--stack-name CyclicAppManagementStack \
	--capabilities CAPABILITY_NAMED_IAM \
	--template-body file://$temp_template \
	--notification-arns arn:aws:sns:us-east-2:758562997317:test-cloudformation-notification

rm $temp_template

# [--stack-policy-url <value> \
#    --template-url httsp://
#    --template-body file://bootstrap.yaml \
# [--tags <value> \
# [--parameters <value> \

# aws cloudformation update-stack \
#     --stack-name CyclicBootstrapStack \
#     --capabilities CAPABILITY_NAMED_IAM \
#     --template-body file://bootstrap.yaml
