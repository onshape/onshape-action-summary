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

echo "Is \`${GITHUB_REF_NAME}\` master, main or rel?"
if [[ ${GITHUB_REF_NAME} == "master" ]]
then
    echo "Yes, master"
    git tag master/latest
elif [[ ${GITHUB_REF_NAME} == "main" ]]
then
    echo "Yes, main"
    git tag main/latest
elif [[ ${GITHUB_REF_NAME} == rel-1.* ]]
then
    echo "Yes, rel"
    git tag rel/latest
else
    echo "No"
fi