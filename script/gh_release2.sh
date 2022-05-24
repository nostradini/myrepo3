
#!/usr/bin/bash

user='nostradini'
repo='myrepo3'
token=$1
tag=$2

curl \
-X POST \
-H "Authorization: token $token" \
-H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/$user/$repo/releases  \
-d '{"tag_name":"$tag","target_commitish":"main","name":"v$tag","body":":big: release again using script","draft":false,"prerelease":false,"generate_release_notes":false}'

# command="curl -s -o release.json -w '%{http_code}' \
#          --request POST \
#          --header 'authorization: token $token' \
#          --header 'content-type: application/json' \
#          --data '{"tag_name": "${tag}"}' \
#          https://api.github.com/repos/$user/$repo/releases"
# http_code=`eval $command`
# if [ $http_code == "201" ]; then
#     echo "created release:"
#     cat release.json
# else
#     echo "create release failed with code '$http_code':"
#     cat release.json
#     echo "command:"
#     echo $command
#     # return 1
# fi

