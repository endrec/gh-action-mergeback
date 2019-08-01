#!/bin/bash
set -eu

env | grep GITHUB

# ASH is magic...
case $GITHUB_REF in
  */master) echo "We are on master, let's merge.";;
         *) echo "Not on master, do nothing."; exit 0;;
esac

payload=$(cat <<EOF 
{
  "base": "${BASE_BRANCH:=develop}",
  "head": "master",
  "commit_message": "Merge back master"
}
EOF
)

output=$( { 
status_code=$(curl --silent -i --output /dev/stderr \
	--write-out "%{http_code}" \
	-H "Authorization: token ${GITHUB_TOKEN}" \
	-X POST https://api.github.com/repos/${GITHUB_REPOSITORY}/merges \
	-d "${payload}")
} 2>&1 )

echo $output

if test ${status_code} -ne 200; then
    echo "The merge has failed with status code ${status_code}"
    exit 1
fi
