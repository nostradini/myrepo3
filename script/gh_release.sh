#!/bin/bash

MESSAGE="0"
VERSION="0.2.0"
DRAFT="false"
PRE="false"
BRANCH="main"
GITHUB_ACCESS_TOKEN=$1

# get repon name and owner
# CD /myrepo3
REPO_REMOTE=$(git config --get remote.origin.url)

if [ -z $REPO_REMOTE ]; then
	echo "Not a git repository"
	exit 1
fi

REPO_NAME=$(basename -s .git $REPO_REMOTE)
REPO_OWNER=$(git config --get user.name)

# get args
while getopts v:m:b:draft:pre: option
do
	case "${option}"
		in
		v) VERSION="$OPTARG";;
		m) MESSAGE="$OPTARG";;
		b) BRANCH="$OPTARG";;
		draft) DRAFT="true";;
		pre) PRE="true";;
	esac
done
if [ $VERSION == "0" ]; then
	echo "Usage: git-release -v <version> [-b <branch>] [-m <message>] [-draft] [-pre]"
	exit 1
fi

# set default message
if [ "$MESSAGE" == "0" ]; then
	MESSAGE=$(printf "Release of version %s" $VERSION)
fi


API_JSON=$(printf '{"tag_name": "v%s","target_commitish": "%s","name": "v%s","body": "%s","draft": %s,"prerelease": %s}' "$VERSION" "$BRANCH" "$VERSION" "$MESSAGE" "$DRAFT" "$PRE" )
API_RESPONSE_STATUS=$(curl -H "Authorization: token $GITHUB_ACCESS_TOKEN" --data "$API_JSON" -s -i https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases?access_token=$GITHUB_ACCESS_TOKEN)
echo "$API_RESPONSE_STATUS"