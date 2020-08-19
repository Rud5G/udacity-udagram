#!/bin/bash

set -ex

export AWS_DEFAULT_PROFILE=udacity1


#echo "Usage: $0 \"param-name\" \"value\" [\"String|SecureString|StringList\" \"description\"]"


aws ssm put-parameter \
    --name "$1" \
    --value "$2" \
    --type "${3:-String}" \
    --description "${4:-}" \
    --overwrite


#aws ssm describe-parameters

if test "$3" == "SecureString";
then
  paramdecryption="--with-decryption"
else
  paramdecryption="--no-with-decryption"
fi


aws ssm get-parameter \
    --name "$1" \
    $paramdecryption

