#!/bin/bash -e
set +x

echo "## \`${GITHUB_WORKFLOW}\` Finished"
echo "Using branch \`${GITHUB_REF_NAME}\`"

if [[ $NPM == "true" ]]
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

echo "Is \`${GITHUB_REF_NAME}\` master, main or rel?"
if [[ ${GITHUB_REF_NAME} == "master" || ${GITHUB_REF_NAME} == "main" || ${GITHUB_REF_NAME} == rel-1.* ]]
then
    echo "Yes"
    mainbranch="true"
else
    echo "No"
    mainbranch="false"
fi

tagname="${GITHUB_REF_NAME}/latest"

if [[ $CHANGESET == "true" ]]
then
    echo "Changeset:"
    echo '```'
    if [[ $(git tag -l ${tagname}) ]]
    then
        echo "Big log:"
        git log --cherry-pick --first-parent --reverse ${tagname}..HEAD
    else
        echo "Small log:"
        git log -n 1
    fi
    echo '```'
fi

if [[ $mainbranch == "true" || $TAGBRANCH == "true" ]]
then
    git tag -d $tagname
    git push --delete origin $tagname
    git tag $tagname
    git push origin --tags
    echo "Tagged ${tagname}"
fi