#!/bin/bash
set -eu

env | grep GITHUB

# ASH is magic...
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
tmp=$(tempfile)
status_code=$(curl --silent -i --output ${tmp} \
	--write-out "%{http_code}" \
	-H "Authorization: token ${GITHUB_TOKEN}" \
	-X POST https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls \
	-d "${payload}")
output=$(cat ${tmp})
rm ${tmp}

if test ${status_code} -ne 201; then
    echo "The merge has failed with status code ${status_code}"
    echo $output
    exit 1
fi

echo "Merging PR..."

pr_no=$(echo $output | jq -r '.number')
tmp=$(tempfile)
status_code=$(curl --silent -i --output ${tmp} \
	--write-out "%{http_code}" \
	-H "Authorization: token ${GITHUB_TOKEN}" \
	-X PUT https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls/${pr_no}/merge )
output=$(cat ${tmp})
rm ${tmp}

echo $output

if test ${status_code} -ne 200; then
    echo "The merge has failed with status code ${status_code}"
    exit 1
fi
