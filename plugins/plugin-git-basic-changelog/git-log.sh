#!/usr/bin/env sh

echo "Generate changelog since last TAG..."
echo -e "# What's Changed\n" > CHANGELOG.md

if $(git describe --tags --abbrev=0 &> /dev/null); then
	# print commit log lines from LAST_TAG to CI_COMMIT_TAG
	if [ "x${CI_COMMIT_TAG}" != "x" ]; then
		LAST_TAG="$(git describe --tags --abbrev=0 ${CI_COMMIT_TAG}^)"
		echo "* LAST_TAG: ${LAST_TAG}"
		echo "* NEW_TAG: ${CI_COMMIT_TAG}"
		git log ${LAST_TAG}..${CI_COMMIT_TAG} --no-merges --pretty="- %s" | tee -a CHANGELOG.md &> /dev/null
		echo -e "\n__**Compare**__: [${LAST_TAG}...${CI_COMMIT_TAG}](${CI_REPO_URL}/compare/${LAST_TAG}...${CI_COMMIT_TAG})" >> CHANGELOG.md
	# print all commit log lines from LAST_TAG
	else
		LAST_TAG="$(git describe --tags --abbrev=0)"
		echo "* LAST_TAG: ${LAST_TAG}"
		git log $(git describe --tags --abbrev=0)..HEAD --no-merges --pretty="- %s" | tee -a CHANGELOG.md &> /dev/null
	fi
else
   # any tag => print all commit log lines
   echo "no TAGs found in this repository!"
   git log --no-merges --pretty="- %s" | tee -a CHANGELOG.md &> /dev/null
fi
echo "done"

if ${PLUGIN_DEBUG:-false}; then
	echo
	cat CHANGELOG.md
fi

exit 0
