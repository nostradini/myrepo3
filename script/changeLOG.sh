# !/usr/bin/bash
Env_Token=$ENV_TOKEN
gitmojiko=$1
newVER=$2
ver_major=$3
ver_minor=$4
ver_patch=$5
user=$6
repo=$7
varDate=$8
targetD=$9
bMajor=false
bMinor=false
bPatch=false
bDefault=false

# targetD="2022-06-01T00:00:00Z"
echo "User= $user , REPO= $repo"
echo "varDate= $varDate"
echo "targetDate = $targetD"
echo "newVer= $newVER"
echo "varDATE= $varDate"

while IFS= read -r line; do
lowerstr=$(echo ${line:41:50}|tr '[:upper:]' '[:lower:]')
# echo "transformed to lower = $lowerstr"
if [[ "${lowerstr}" != "[job]"* ]]
then
    if [[ "${lowerstr}" == *"#major"* ]]
    then
    # echo "Found major in commit"
    bMajor=true
    colMajor="$colMajor <li><a href='https://github.com/$user/$repo/commit/${line:0:7}'> ${line:0:7} </a> - ${line:41:50} </li>"
    elif [[ "${lowerstr}" == *"#minor"* ]]
    then
    # echo "Found minor in commit"
    bMinor=true
    colMinor="$colMinor <li><a href='https://github.com/$user/$repo/commit/${line:0:7}'> ${line:0:7} </a> - ${line:41:50} </li>"
    elif [[ "${lowerstr}" == *"#patch"* ]]
    then
    # echo "Found patch in commit"
    bPatch=true
    colPatch="$colPatch <li><a href='https://github.com/$user/$repo/commit/${line:0:7}'> ${line:0:7} </a> - ${line:41:50} </li>"
    else
    # echo "Default condition"
    bDefault=true
    colDefault="$colDefault <li> ${line:0:7} - ${line:41:50} </li>"
    fi
fi
done < <( git log --after="$targetD" --format=oneline )

if [[ ${#colMajor} != 0 ]]
then
    MjTitle="<ul><li><h4>Major Changes</h4></li>"
    if [[ ${#colMinor} != 0 ]] || [[ ${#colPatch} != 0 ]]
    then
    colMajor="<ul><h6>$colMajor</h6></ul>"
    else
    colMajor="<ul><h6>$colMajor</h6></ul></ul>"
    fi
fi
if [[ ${#colMinor} != 0 ]]
then
    if [[ ${#colMajor} != 0  ]]
    then
    MnTitle="<li><h4>Minor Changes</h4></li>"
    else
    MnTitle="<ul><li><h4>Minor Changes</h4></li>"
    fi
    if [[ ${#colPatch} != 0 ]]
    then
    colMinor="<ul><h5>$colMinor</h5></ul>"
    else
    colMinor="<ul><h5>$colMinor</h5></ul></ul>"
    fi
fi
if [[ ${#colPatch} != 0 ]]
then
    if [[ ${#colMinor} != 0 ]] || [[ ${#colMajor} != 0 ]]
    then
    PtTitle="<li><h4>Patches</h4></li>"
    colPatch="<ul><h5>$colPatch</h5></ul></ul>"
    else
    PtTitle="<ul><li><h4>Patches</h4></li>"
    colPatch="<ul><h5>$colPatch</h5></ul></ul>"
    fi

fi
newVER="v$newVER"
path="CHANGELOG.md"
copyCL=$(cat ./$path)

# echo "Updated Version = " $UpdatedVer
# echo "MjTitle=$MjTitle,MnTitle=$MnTitle,PtTitle=$PtTitle"
content="<h1>CHANGELOG</h1><h2>$newVER - $varDate</h2><h3>$gitmojiko</h3> $MjTitle $colMajor $MnTitle $colMinor $PtTitle $colPatch <br> $copyCL"

echo "content= $content"

echo "path= $path"

Repo_SHA=$(curl -H "Authorization: token $Env_Token" \
-X GET https://api.github.com/repos/$user/$repo/contents/$path | jq .sha)

# echo "This is repo_sha = " $Repo_SHA

content=$(echo $content | base64)
content=$(echo $content | tr -d ' ')
content=\"${content}\"
# echo "Content is = " $content

prep_data()
{
  cat <<EOF
{
  "path": "$path",
  "message":"[JOB] Push $path update",
  "branch":"main",
  "sha": $Repo_SHA,
  "content": $content
  }
EOF
}
# echo "prep data= $(prep_data)"

curl -i -X PUT \
-H "Authorization: token $Env_Token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/contents/$path \
-d "$(prep_data)"
 