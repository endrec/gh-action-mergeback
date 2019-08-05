#!/bin/bash
set -eu

merge_instructions=.github/merge-instructions.md

# env | grep GITHUB

case $GITHUB_REF in
  */master) echo "We are on master, let's merge.";;
         *) echo "Not on master, do nothing."; exit 0;;
esac


# Let's create a PR

echo "Creating a PR..."
payload=$(cat <<EOF 
{
  "base": "${BASE_BRANCH:=develop}",
  "head": "master",
  "title": "Merging back master"
}
EOF
)
tmp=$(mktemp)
status_code=$(curl --silent --output ${tmp} \
    --write-out "%{http_code}" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Content-type: application/json" \
    -X POST https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls \
    -d "${payload}")
output=$(cat ${tmp})
rm ${tmp}

if test ${status_code} -ne 201; then
    echo "Creating a PR has failed with status code ${status_code}"
    echo $output | jq
    exit 1
fi
echo "Merging PR..."
pr_no=$(echo $output | jq -r '.number')

tmp=$(mktemp)
status_code=$(curl --silent --output ${tmp} \
    --write-out "%{http_code}" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Content-type: application/json" \
    -X PUT https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${pr_no}/merge )
output=$(cat ${tmp})
rm ${tmp}

if test ${status_code} -ne 200; then
    echo "The merge has failed with status code ${status_code}"
    echo $output | jq
    
    if [ -e ${merge_instructions} ] ; then
		echo "Updating PR description..."
		payload=$(cat <<EOF 
{
  "body": "$(cat ${merge_instructions})"
}
EOF
)
		curl --silent --fail \
		  -H "Authorization: token ${GITHUB_TOKEN}" \
		  -H "Content-type: application/json" \
		  -X PATCH https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${pr_no} \
		  -d "${payload}"
	fi

	echo "Requesting review from ${GITHUB_ACTOR}"
    payload=$(cat <<EOF 
{
  "reviewers": [
    "${GITHUB_ACTOR}"
  ]
}
EOF
)
    curl --silent --output /dev/null --fail \
      -H "Authorization: token ${GITHUB_TOKEN}" \
      -H "Content-type: application/json" \
      -X POST https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${pr_no}/requested_reviewers \
      -d "${payload}"
    exit 1
fi
