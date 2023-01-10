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

if $TAGBRANCH
then
    git tag ${GITHUB_REF_NAME}/latest
    git push origin ${GITHUB_REF_NAME}/latest
    echo "Tagged ${GITHUB_REF_NAME}/latest"
fi

echo "Is \`${GITHUB_REF_NAME}\` master, main or rel?"
if [[ ${GITHUB_REF_NAME} == "master" || ${GITHUB_REF_NAME} == "main" || ${GITHUB_REF_NAME} == rel-1.* ]]
then
    echo "Yes"
    git tag ${GITHUB_REF_NAME}/latest
    git push origin ${GITHUB_REF_NAME}/latest
else
    echo "No"
fi