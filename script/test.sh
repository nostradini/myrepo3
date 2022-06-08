# !/usr/bin/bash
gUSER="$(git log -n 1 --pretty=format:%an)"
lastCommit=$(git log --format=%B -n 1 HEAD)
repo=$REPO

d1=$(date +'%Y-%m-%d')
d2=$(date +'%T')
d2=$(echo $d2 | tr -d ':')
varDate="$d1-$d2"

targetD=$(curl \
-H "Accept: application/vnd.github.v3+json" \
"https://api.github.com/repos/$gUSER/$repo/releases/latest" | jq .created_at)

echo "Last commit = $lastCommit" 
echo "Git User = $gUSER"
echo "REPO= $repo"
echo $(date +'%Y-%m-%d')
echo $(date +'%T')
echo "Generated Date= $varDate"
echo "targetD= $targetD"

echo "::set-output name=LASTCOM::$lastCommit"
echo "::set-output name=USER::$gUSER"
echo "::set-output name=envDATE::$varDate"
echo "::set-output name=envTDATE::$targetD"