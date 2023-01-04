#!/bin/bash -ex

name=$(node -p "require('./package.json').name")
version=$(node -p "require('./package.json').version")

sha=$(git rev-parse HEAD)
shortSHA=${sha:0:12}
{
    #echo "Published \`${GITHUB_REF_NAME}\` [onshape-ng-modules@${shortSHA}](https://github.com/${GITHUB_REPOSITORY}/commit/${sha}) as NPM version ${version}"
    echo "OUTCOME: ${TEST_OUTCOME}"
    if [ $? -eq 0 ]
    then
        echo "## \`${GITHUB_WORKFLOW}\` Passed!"
    else
        echo "## \`${GITHUB_WORKFLOW}\` Failed!"
    fi
    echo "Using branch \`${GITHUB_REF_NAME}\`"
    echo '```'
    git show HEAD --name-only
    echo '```'
} >> $GITHUB_STEP_SUMMARY