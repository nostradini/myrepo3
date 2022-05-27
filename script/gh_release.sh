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
data="### $ENV_GM \n $com_hash $ENV_MSG"

You don't need to pass the quotes enclosing the custom headers to curl. Also, your variables in the middle of the data argument should be quoted.

First, write a function that generates the post data of your script. This saves you from all sort of headaches concerning shell quoting and makes it easier to read an maintain the script than feeding the post data on curl's invocation line as in your attempt:

prep_post_data()
{
  cat <<EOF
{
  "tag_name": "$tag",
  "target_commitish":"main" , 
  "name": "$vtag" ,
  "body": "$data" ,
  "draft":false,"prerelease":false,
  "generate_release_notes":false
}
EOF
}

curl \
-X POST \
-H "Authorization: token $token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases  \
-d "$(prep_post_data)"

# {"tag_name": '$tag' ,
# "target_commitish":"main" , 
# "name": '$vtag' ,
# "body": '$data' ,
# "draft":false,"prerelease":false,
# "generate_release_notes":false}'