#!/bin/bash

export AWS_DEFAULT_PROFILE=udacity1

set -ex

aws ssm get-parameter \
  --name "$1" \
  --with-decryption
