
!/usr/bin/bash
user="nostradini"
repo="myrepo3"
token=$1
tag=$2

echo "tag" $tag
vtag="v$tag"
tag=\"${tag}\"
vtag=\"${vtag}\"
echo $tag $vtag

curl \
-X POST \
-H "Authorization: token $token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases  \
-d '{"tag_name": '$tag' ,"target_commitish":"main" , "name": '$vtag' ,"body": "# :bug: release again using script","draft":false,"prerelease":false,"generate_release_notes":false}'
