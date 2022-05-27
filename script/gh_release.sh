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
echo "message= " $ENV_MSG

gm_type="$(cut -d' ' -f1 <<< "$ENV_GM")"
gm_desc1="$(cut -d' ' -f2 <<< "$ENV_GM")"
gm_desc2="$(cut -d' ' -f3 <<< "$ENV_GM")"

echo "split - $gm_type , $gm_desc1 , $gm_desc2"

vtag="v$tag"
tag=\"${tag}\"
vtag=\"${vtag}\"
echo $tag $vtag
# $gm_type $gm_desc1 $gm_desc2 
data="### '$ENV_GM' \n '$com_hash' '$ENV_MSG'"
data=\"${data}\"
echo "data=" $data

curl \
-X POST \
-H "Authorization: token $token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases  \
-d '{"tag_name": '$tag' ,
"target_commitish":"main" , 
"name": '$vtag' ,
"body": '$data' ,
"draft":false,"prerelease":false,
"generate_release_notes":false}'