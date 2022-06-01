# !/usr/bin/bash

targetD=$(curl \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases/latest | jq .created_at)

arrCom=()
while IFS= read -r line; do
arrCom+=( "$line" )
data="$data * ${line:0:7} - ${line:41:50} \n "
done < <( git log --after="$targetD" --format=oneline )
echo ${#arrCom[@]}