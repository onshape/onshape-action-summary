#!/bin/bash -e

echo "## \`${GITHUB_WORKFLOW}\` Finished"
echo "Using branch \`${GITHUB_REF_NAME}\`"

pwd

if $NPM
then
    name=`node -p "require('./package.json').name"`
    version=`node -p "require('./package.json').version"`

    echo "NPM: \`${name} - ${version}\`"
fi

if [ "${TEXT}" ]
then
     echo "Text: ${TEXT}"
fi

echo "Last commit: ${LAST_SUCCESSFUL_COMMIT}"

echo '```'
if $CHANGESET && [ $LAST_SUCCESSFUL_COMMIT ]
then
    git log --cherry-pick --first-parent --reverse ${LAST_SUCCESSFUL_COMMIT}..HEAD
else
    git log -1
fi
echo '```'