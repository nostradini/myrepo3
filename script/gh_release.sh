# !/usr/bin/bash
user="$(git log -n 1 --pretty=format:%an)"
repo="myrepo3"
com_hash="$(git rev-parse --short HEAD)"
token=$1
tag=$ENV_VER

echo "END_GM= " $ENV_GM
echo "ENV_VER= " $ENV_VER
echo "User= " $user
# echo "Message= " $ENV_MSG

vtag="v$tag"
tag=\"${tag}\"
vtag=\"${vtag}\"
echo $tag $vtag

targetD=$(curl \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases/latest | jq .created_at)

echo "target date= $targetD"
data="### $ENV_GM \n "

arrCom=()
while IFS= read -r line; do
    arrCom+=( "$line" )
    # echo "arrCom = " ${line:0:7}
    # echo ${line:41:50}
    data="$data * ${line:0:7} - ${line:41:50} \n "
done < <( git log --after="$targetD" --format=oneline )
echo "Data= " $data

prep_post_data()
{
  cat <<EOF
{
  "tag_name": $tag,
  "target_commitish":"main" , 
  "name": $vtag ,
  "body": "$data" ,
  "draft":false,"prerelease":false,
  "generate_release_notes":false
}
EOF
}

echo "$(prep_post_data)"

curl \
-X POST \
-H "Authorization: token $token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases  \
-d "$(prep_post_data)"
