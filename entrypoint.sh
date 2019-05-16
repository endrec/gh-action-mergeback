#!/bin/sh
set -eu

# ASH is magic...
case $GITHUB_REF in
  */master) echo "We are on master, let's merge.";;
         *) echo "Not on master, do nothing."; exit 0;;
esac

cat <<EOF | 
{
  "base": "${BASE_BRANCH:=develop}",
  "head": "master",
  "commit_message": "Merge back master"
}
EOF
curl -i -H "Authorization: token ${GITHUB_TOKEN}" -X POST https://api.github.com/repos/${GITHUB_REPOSITORY}/merges -d @-

