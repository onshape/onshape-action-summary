#!/bin/bash -e
set +x

echo "## \`${GITHUB_WORKFLOW}\` Finished"
echo "Used branch \`${GITHUB_REF_NAME}\`"

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

if [[ ${GITHUB_REF_NAME} == "master" || ${GITHUB_REF_NAME} == "main" || ${GITHUB_REF_NAME} == rel-1.* ]]
then
    mainbranch="true"
else
    mainbranch="false"
fi

tagname="${GITHUB_REF_NAME}/latest"
git fetch --all --tags

git branch

if [[ $CHANGESET == "true" ]]
then
    echo "Changeset:"
    echo '```'
    if [[ $(git tag -l ${tagname}) ]]
    then
        git log --cherry-pick --first-parent --reverse ${tagname}..HEAD --compact-summary
    else
        git log -n 1 --compact-summary
    fi
    echo '```'
fi

if [[ $mainbranch == "true" || $TAGBRANCH == "true" ]]
then
    #git tag -d $tagname
    git push --delete origin $tagname
    git tag $tagname
    git push origin --tags
    echo "Tagged ${tagname}"
fi