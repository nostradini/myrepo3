#!/usr/bin/bash
TokenVar=$1
Repo_SHA=$(curl -X GET https://api.github.com/repos/nostradini/MYREPO4/contents/CHANGELOG.md | jq .sha)
echo "This is repo_sha = $Repo_SHA"

UpdatedVer=$(cat ./CHANGELOG.md)

echo "Changelog = " $UpdatedVer

content=$(echo $UpdatedVer | base64)
content=$(echo $content | tr -d ' ')
content=\"${content}\"
echo "Content is = " $content

# curl -i -X PUT \
# -H "Authorization: token $TokenVar" \
# -H "Accept: application/vnd.github.v3+json" \
# -d '{ "path":"CHANGELOG.md","message":"docs: update CHANGELOG.md","content":'$content',"branch":"main","sha":'$Repo_SHA' }' \
#  https://api.github.com/repos/nostradini/MYREPO4/contents/CHANGELOG.md