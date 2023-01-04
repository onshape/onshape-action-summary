#!/bin/bash -ex

#name=$(node -p "require('./package.json').name")
#version=$(node -p "require('./package.json').version")

#sha=$(git rev-parse HEAD)
#shortSHA=${sha:0:12}
#echo "Published \`${GITHUB_REF_NAME}\` [onshape-ng-modules@${shortSHA}](https://github.com/${GITHUB_REPOSITORY}/commit/${sha}) as NPM version ${version}"
echo "## \`${GITHUB_WORKFLOW}\` Finished"
echo "Using branch \`${GITHUB_REF_NAME}\`"
echo '```'
git log -1
echo '```'