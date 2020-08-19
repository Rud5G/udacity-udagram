#!/bin/bash

set -ex

export AWS_DEFAULT_PROFILE=udacity1


#echo "Usage: $0 \"param-name\" \"value\" [\"String|SecureString|StringList\" \"description\"]"



aws ssm describe-parameters

