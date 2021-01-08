#!/usr/bin/env bash
set -ex

aws --version

aws cloudformation create-stack \
    --stack-name CyclicBootstrapStack \
    --template-url httsp://
    --capabilities CAPABILITY_NAMED_IAM

# [--stack-policy-url <value> \
#    --template-body file://bootstrap.yaml \
# [--tags <value> \
# [--parameters <value> \
