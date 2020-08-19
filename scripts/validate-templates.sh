#!/bin/bash

# shellcheck source=./common.sh
. "$(dirname "$0")/common.sh"

export AWS_DEFAULT_PROFILE=udacity1
set -ex



msg "Validating AWS CloudFormation templates..."

recursive_validate_cfn_directory './infrastructure/'







  #export ERROR_COUNT=0;
  ## Loop through the yml templates in this repository
  #for TEMPLATE in $(find . -name '*.yml'); do
  #
  #    # Validate the template with CloudFormation
  #    ERRORS=$(aws cloudformation validate-template --template-body file://$TEMPLATE 2>&1 >/dev/null);
  #    if [ "$?" -gt "0" ]; then
  #        ((ERROR_COUNT++));
  #        echo "[fail] $TEMPLATE: $ERRORS";
  #    else
  #        echo "[pass] $TEMPLATE";
  #    fi;
  #
  #done;
  #
  #echo "$ERROR_COUNT template validation error(s)";
  #if [ "$ERROR_COUNT" -gt 0 ];
  #    then exit 1;
  #fi
  #

