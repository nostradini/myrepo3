# !/usr/bin/bash
gUSER="$(git log -n 1 --pretty=format:%an)"
lastCommit=$(git log --format=%B -n 1 HEAD)
echo "Last commit = $lastCommit" 
echo "::set-output name=LASTCOM::$lastCommit"
echo "Git User = $gUSER" 
echo "::set-output name=USER::$gUSER"

d1=$(date +"%Y-%m-%d")
d2=$(date +"%T")
d2=$(echo $d2 | tr -d ':')
varDate="$d1-$d2"
echo "::set-output name=envDATE::$varDate"

targetD=$(curl \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases/latest | jq .created_at)

echo "::set-output name=envTDATE::$targetD" 