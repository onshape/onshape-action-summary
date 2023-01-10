#!/bin/bash -ex

echo "## \`${GITHUB_WORKFLOW}\` Finished"
echo "Using branch \`${GITHUB_REF_NAME}\`"

if $NPM
then
    if [[ -f "./package.json" ]]
    then
        name=`node -p "require('./package.json').name"`
        version=`node -p "require('./package.json').version"`

        echo "NPM: \`${name} - ${version}\`"
    else
        echo "NPM not found"
    fi
fi

if [[ "${TEXT}" ]]
then
     echo $(eval "echo $TEXT")
fi

echo "Last commit: ${LAST_SUCCESSFUL_COMMIT}"


if $CHANGESET
then
    echo '```'
    if [[ $LAST_SUCCESSFUL_COMMIT ]]
    then
        git log --cherry-pick --first-parent --reverse ${LAST_SUCCESSFUL_COMMIT}..HEAD
    else
        git log -n 1
    fi
    echo '```'
fi

echo "Is master?"
if [[ ${GITHUB_REF_NAME} -eq "master" ]]
then
    echo "Yes"
else
    echo "No"
fi