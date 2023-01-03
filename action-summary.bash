#!/usr/bin/env bash

set +x

set -o errexit
set -o pipefail
set -o xtrace

# Summary
echo "Output file: "
echo $GITHUB_STEP_SUMMARY
{
    echo "OUTPUT: "
    echo ${INPUT_STRING}

} >> $GITHUB_STEP_SUMMARY