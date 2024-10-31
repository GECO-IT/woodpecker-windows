#!/usr/bin/env sh

set -e

# Teams ActiveCard try: https://adaptivecards.io/designer

if [ "x${PLUGIN_URL}" == "x" ]; then
    echo "Need to set MS Teams Webhook URL"
    exit 1
fi

if [ "x${CI_COMMIT_TAG}" == "x" ]; then
    PROJECT_VERSION="${CI_COMMIT_SHA:0:10}"
else
    PROJECT_VERSION="${CI_COMMIT_TAG}"
fi

DATE='+%Y-%m-%dT%H:%M:%SZ'
DATESTR=$(date -u -d "@${CI_PIPELINE_FINISHED}" "${DATE}")

sed -i "s/TEMPLATE_BUILD_URL/${CI_PIPELINE_URL//\//\\/}/" /data/card.json
sed -i "s;TEMPLATE_PROJECT_NAME;${CI_REPO};" /data/card.json
sed -i "s/TEMPLATE_PROJECT_VERSION/${PROJECT_VERSION}/" /data/card.json
COMMIT_MSG_ESCAPED=$(echo "${CI_COMMIT_MESSAGE}" | head -n 1 | sed "s/;/\;/g")
sed -i "s;TEMPLATE_COMMIT_MESSAGE;${COMMIT_MSG_ESCAPED};" /data/card.json

if [ "x${CI_COMMIT_TAG}" != "x" ]; then
	sed -i "s;TEMPLATE_COMMIT_URL;${CI_REPO_URL}/releases/tag/${CI_COMMIT_TAG};" /data/card.json
	sed -i "s/TEMPLATE_COMMIT_BUTTON/View Release/" /data/card.json
else
	sed -i "s;TEMPLATE_COMMIT_URL;${CI_PIPELINE_FORGE_URL};" /data/card.json
	sed -i "s/TEMPLATE_COMMIT_BUTTON/View Commit changes/" /data/card.json
fi

sed -i "s/TEMPLATE_AUTHOR/${CI_COMMIT_AUTHOR}/" /data/card.json
sed -i "s;TEMPLATE_DATE;${DATESTR};g" /data/card.json

if [ "x${CI_COMMIT_AUTHOR_AVATAR}" != "x" ]; then
	if ${PLUGIN_PRIVATE_FORGE:-false}; then
		echo "Transform Avatar Image to Base64 URI..."
		curl -fSsL -o /avatar.img ${CI_COMMIT_AUTHOR_AVATAR} || { echo "Download avatar image failed!"; exit 1; }
		imgtype="$(/GnuWin/bin/file.exe --mime-type /avatar.img | awk '{print $NF}')"
		magick /avatar.img -resize 50x50\> /avatar.img2
		TEMPLATE_IMAGE_AUTHOR="data:${imgtype};base64,$(base64 -w 0 /avatar.img2)"
		sed -i "s|TEMPLATE_IMAGE_AUTHOR|${TEMPLATE_IMAGE_AUTHOR}|" /data/card.json
	else
		sed -i "s;TEMPLATE_IMAGE_AUTHOR;${CI_COMMIT_AUTHOR_AVATAR};" /data/card.json
	fi
fi

if [ "${CI_PIPELINE_STATUS}" == "failure" ]; then
    sed -i 's/TEMPLATE_TITLE/❌ Pipeline failed/' /data/card.json
    sed -i 's/TEMPLATE_COLOR/attention/g' /data/card.json
else
    sed -i 's/TEMPLATE_TITLE/✔ Pipeline successfully completed/' /data/card.json
    sed -i 's/TEMPLATE_COLOR/good/g' /data/card.json
fi

if ${PLUGIN_DEBUG:-false}; then
	echo -e "\nDebug result json:"
	cat /data/card.json
fi

echo -e "\nCI Build Card Info:"
echo "- PROJECT NAME: ${CI_REPO}"
echo "- PROJECT_VERSION: ${PROJECT_VERSION}"
echo "- PROJECT STATUS: ${CI_PIPELINE_STATUS}"
echo "- PROJECT BUILD DATE: ${DATESTR}"

echo -e "\nSend card to Microsoft Teams... "
curl -fSsL -H "Content-Type: application/json" -X POST -d "@C:\\data\\card.json" "${PLUGIN_URL}" || exit 1

exit 0
