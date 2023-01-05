#!/bin/bash -ex

echo "## \`${GITHUB_WORKFLOW}\` Finished"
echo "Using branch \`${GITHUB_REF_NAME}\`"

echo "DO-NPM: ${DO-NPM}"
if $DO-NPM
then
    name=$(node -p "require('./package.json').name")
    version=$(node -p "require('./package.json').version")

    echo "Npm Name: $name"
    echo "Npm Name: $version"
fi

if [ $TEXT ]
then
     echo "${TEXT}"
fi

echo '```'
if $CHANGESET
then
    git log --cherry-pick --first-parent --reverse ${LAST_SUCCESSFUL_COMMIT}..HEAD
else
    git log -1
fi
echo '```'