#!/usr/bin/env sh

set -e

say() {
  if [ -n "$2" ]; then
    printf "🤖 \e[32mgitea-package\e[0m \e[36m[⚒️ %s]\e[0m: %s \n" "$2" "$1"
  else
    printf "🤖 \e[32mgitea-package\e[0m: %s \n" "$1"
  fi
}

sayE() {
  if [ -n "$2" ]; then
    printf "🤖 \e[31mgitea-package\e[0m \e[36m[⚒️ %s]\e[0m: %s \n" "$2" "$1" 1>&2
  else
    printf "🤖 \e[31mgitea-package\e[0m: %s \n" "$1" 1>&2
  fi
}

sayW() {
  if [ -n "$2" ]; then
    printf "🤖 \e[33mgitea-package\e[0m \e[36m[⚒️ %s]\e[0m: %s \n" "$2" "$1" 1>&2
  else
    printf "🤖 \e[33mgitea-package\e[0m: %s \n" "$1" 1>&2
  fi
}

# TODO: Disabled for now. No default help output needed if just running as
# Woodpecker CI plugin.
#
#showHelp() {
#  cat << HELP
#  🤖 gitea-package Woodpecker-CI Plugin
#
#  Syntax:
#HELP
#}

showENV() {
  env | sort
}

showSettings() {
  say "PLUGIN_OWNER: $PLUGIN_OWNER" "showSettings"
  say "PLUGIN_PACKAGE_NAME: $PLUGIN_PACKAGE_NAME" "showSettings"
  say "PLUGIN_PACKAGE_VERSION: $PLUGIN_PACKAGE_VERSION" "showSettings"
  say "PLUGIN_FILE_SOURCE: $PLUGIN_FILE_SOURCE" "showSettings"
  say "PLUGIN_FILE_NAME: $PLUGIN_FILE_NAME" "showSettings"
  say "PLUGIN_UPDATE: ${PLUGIN_UPDATE:-false}" "showSettings"
}

testArtifact() {
  tout=$(curl --silent --output /dev/null --write-out "%{http_code}" \
    "$CI_FORGE_URL/api/packages/$PLUGIN_OWNER/generic/$PLUGIN_PACKAGE_NAME/$PLUGIN_PACKAGE_VERSION/$PLUGIN_FILE_NAME")

  if [ "$tout" = "200" ]; then
    echo "true"
  else
    echo "false"
  fi
}

deleteArtifact() {
  dout=$(curl --silent --write-out "%{http_code}" \
    --user "$PLUGIN_USER:$PLUGIN_PASSWORD" -X DELETE \
    "$CI_FORGE_URL/api/packages/$PLUGIN_OWNER/generic/$PLUGIN_PACKAGE_NAME/$PLUGIN_PACKAGE_VERSION/$PLUGIN_FILE_NAME")

  if [ "$dout" = "204" ]; then
    say "Old package file deleted" "deleteArtifact"
  elif [ "$dout" = "404" ]; then
    sayE "The package or file was not found." "deleteArtifact"
    exit 1
  else
    sayE "Unknown curl response! ($dout)" "deleteArtifact"
    exit 1
  fi
}

uploadArtifact() {
  say "Testing if the given artifact already exists in the package registry..." "uploadArtifact"
  fexist=$(testArtifact)
  if [ "$fexist" = "true" ]; then
    if ${PLUGIN_UPDATE:-false}; then
      sayW "🚧 Given file already exists. Removing remote file..." "uploadArtifact"
      deleteArtifact
    else
      sayW "🛑 File already exists in the package registry." "uploadArtifact"
      exit 1
    fi
  fi
  say "Starting file upload... ($PLUGIN_FILE_SOURCE)" "uploadArtifact" 
  cout=$(curl --silent --write-out "%{http_code}" \
    --user "$PLUGIN_USER:$PLUGIN_PASSWORD" \
    --upload-file "$PLUGIN_FILE_SOURCE" \
    "$CI_FORGE_URL/api/packages/$PLUGIN_OWNER/generic/$PLUGIN_PACKAGE_NAME/$PLUGIN_PACKAGE_VERSION/$PLUGIN_FILE_NAME")
  say "Curl http response code: $cout" "uploadArtifact"

  if [ "$cout" = "201" ]; then
    say "Upload sucessfully finished. ✅" "uploadArtifact"
    exit 0
  elif [ "$cout" = "400" ]; then
    sayE "Upload failed! (Bad Request) 💣" "uploadArtifact"
    exit 1
  elif [ "$cout" = "409" ]; then
    sayE "File already exists in package version! 🛑" "uploadArtifact"
  else
    sayE "Unknown upload response! ($cout) 💣" "uploadArtifact"
    exit 1
  fi
}

# Force debug
PLUGIN_DEBUG=true

main() {
  if [ -n "$PLUGIN_DEBUG" ]; then
    #sayW "🐞 Debug mode enabled."
    showSettings
    #sayW "Available ENV vars:"
    #showENV
  fi
  
  if [ ! -e ${PLUGIN_FILE_SOURCE} ]; then
    sayE "🛑 Source File (${PLUGIN_FILE_SOURCE}) dont exist!"
	exit 1
  fi
  
  uploadArtifact
}

main "$@"
