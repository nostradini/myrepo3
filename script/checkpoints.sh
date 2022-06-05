# !/usr/bin/bash

gUSER="$(git log -n 1 --pretty=format:%an)"
lastCommit=$(git log --format=%B -n 1 HEAD)
echo "Last commit = $lastCommit" 
echo "::set-output name=LASTCOM::$lastCommit"
echo "Git User = $gUSER" 
echo "::set-output name=USER::$gUSER"
