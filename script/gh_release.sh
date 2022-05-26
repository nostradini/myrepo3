# !/usr/bin/bash
user="$(git log -n 1 --pretty=format:%an)"
repo="myrepo3"
# target="$(git symbolic-ref --short HEAD)"
com_hash="$(git rev-parse --short HEAD)"
token=$1
tag=$ENV_VER

echo "END_GM= " $ENV_GM
echo "ENV_VER= " $ENV_VER

echo "user= " $user
echo "tag = " $ENV_VER

vtag="v$tag"
tag=\"${tag}\"
vtag=\"${vtag}\"
echo $tag $vtag

curl \
-X POST \
-H "Authorization: token $token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases  \
-d '{"tag_name": '$tag' ,"target_commitish":"main" , "name": '$vtag' ,"body": "### '$ENV_GM' \n '$com_hash' - release again using script","draft":false,"prerelease":false,"generate_release_notes":false}'
