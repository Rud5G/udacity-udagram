#!/bin/bash

set -u
#set -x
set -e






# If true, all messages will be printed. If false, only fatal errors are printed.
DEBUG=true


# Under normal circumstances, you shouldn't need to change anything below this line.
# -----------------------------------------------------------------------------



function cfnWaitForCreateStackComplete() {
  local stackId="$1"
  aws cloudformation wait stack-create-complete --stack-name "${stackId}"
}
function cfnWaitForUpdateStackComplete() {
  local stackId="$1"
  aws cloudformation wait stack-update-complete --stack-name "${stackId}"
}
function cfnWaitForDeleteStackComplete() {
  local stackId="$1"
  aws cloudformation wait stack-delete-complete --stack-name "${stackId}"
}


function cfnCreateStack() {
  local stack_name="$1"
  local template_file="$2"
  local parameters_file="$3"
  local region="${4:-us-west-2}"
  local stack_id

  stack_id=$(aws cloudformation create-stack \
    --stack-name "$stack_name" \
    --template-body "file://$template_file"  \
    --parameters "file://$parameters_file" \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
    --region="$region" | jq -r '.StackId')

  msg "creating stack, waiting to complete."

  cfnWaitForCreateStackComplete "$stack_id"
  return $?
}

function cfnUpdateStack() {
  local stack_name="$1"
  local template_file="$2"
  local parameters_file="$3"
  local region="${4:-us-west-2}"
  local stack_id

  stack_id=$(aws cloudformation update-stack \
    --stack-name "$stack_name" \
    --template-body "file://$template_file"  \
    --parameters "file://$parameters_file" \
    --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM" \
    --region="$region" | jq -r '.StackId')

  msg "updating stack, waiting to complete."

  cfnWaitForUpdateStackComplete "$stack_id"
  return $?
}

#createStackAndWait "${basestackname}-vpc" "infrastructure/fp3-vpc.yml" "infrastructure/fp3-vpc-parameters.json"
#createStackAndWait "${basestackname}-security-groups" "infrastructure/fp3-security-groups.yml" "infrastructure/fp3-security-groups-parameters.json"
#createStackAndWait "${basestackname}-servers" "infrastructure/fp3-servers.yml" "infrastructure/fp3-servers-parameters.json"




# Usage: get_glob_files_in_directory
#
#   Searches files in a directory by glob. Returns non-zero if invalid or zero otherwise.
get_glob_files_in_directory() {
    local directory="$1"
    local glob="${2:-*.yml}"


    find "$directory" -type f -name "$glob"
    return $?
}


recursive_validate_cfn_directory() {
    local directory="$1"
    local path

    path=$(get_abs_filename "$directory")
    
    for template in $(get_glob_files_in_directory "$path"); do
        local errors
        errors=$(validate_cfn_template_file "$template")
        if test $?; then
            echo "[pass] $template";
        else
            echo "[fail] $template: $errors";
        fi
    done;
}


# Usage: validate_cfn_template_file
#
#   Writes to STDOUT the Errors in the CloudFormation Script. Returns non-zero if invalid or zero otherwise.
validate_cfn_template_file() {
    local template_file="$1"

    aws cloudformation validate-template --template-body "file://$template_file" >/dev/null 2>&1
    return $?
}

# Usage: get_instance_region
#
#   Writes to STDOUT the AWS region as known by the local instance.
get_instance_region() {
    if [ -z "$AWS_REGION" ]; then
        AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document \
            | grep -i region \
            | awk -F\" '{print $4}')
    fi

    echo "$AWS_REGION"
}

# Usage: msg <message>
#
#   Writes <message> to STDERR only if $DEBUG is true, otherwise has no effect.
msg() {
    local message=$1
    $DEBUG && echo "$message" 1>&2
    return 0
}

# Usage: error_exit <message>
#
#   Writes <message> to STDERR as a "fatal" and immediately exits the currently running script.
error_exit() {
    local message=$1

    echo "[FATAL] $message" 1>&2
    exit 1
}

# Usage: get_instance_id
#
#   Writes to STDOUT the EC2 instance ID for the local instance. Returns non-zero if the local
#   instance metadata URL is inaccessible.
get_instance_id() {
    curl -s http://169.254.169.254/latest/meta-data/instance-id
    return $?
}

# Usage: get_account_nr
#
#
#   Writes to STDOUT the account nr of the active AWS account
get_account_nr() {
    aws sts get-caller-identity --output text --query Account
    return $?
}

get_abs_filename() {
  local path="$1"
  # $path : relative filename
  if [ -d "$(dirname "$path")" ]; then
    echo "$(cd "$(dirname "$path")" && pwd)/$(basename "$path")"
  fi
}