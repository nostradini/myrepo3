# !/usr/bin/bash
user="$(git log -n 1 --pretty=format:%an)"
repo="myrepo3"
# target="$(git symbolic-ref --short HEAD)"
com_hash="$(git rev-parse --short HEAD)"
token=$1
tag=$2

tag=$sh_ver
echo "sh version= " $gh_sh_ver
echo "release gitmoji= " $ENV_GM

echo "user= " $user
echo "tag = " $tag

vtag="v$tag"
tag=\"${tag}\"
vtag=\"${vtag}\"
echo $tag $vtag

# curl \
# -X POST \
# -H "Authorization: token $token" \
# -H "Accept: application/vnd.github.v3+json" \
# https://api.github.com/repos/$user/$repo/releases  \
# -d '{"tag_name": '$tag' ,"target_commitish":"main" , "name": '$vtag' ,"body": "### '$gitmojiko' Bug Fixes \n '$com_hash' - release again using script","draft":false,"prerelease":false,"generate_release_notes":false}'
