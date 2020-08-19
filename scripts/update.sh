#!/bin/bash

# shellcheck source=./common.sh
. "$(dirname "$0")/common.sh"

export AWS_DEFAULT_PROFILE=udacity1


if test "$#" -ne 3;
then
    msg ""
    msg "Usage: $0 <stack_name> <template_file> <parameters_file>"
    msg ""
    error_exit "Invalid nr of params."
fi

set -ex

cfnUpdateStack "$1" "$2" "$3"

#aws cloudformation update-stack \
#  --stack-name "$1" \
#  --template-body file://$2  \
#  --parameters file://$3 \
#  --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
#  --region=us-west-2
