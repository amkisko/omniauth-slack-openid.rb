#!/bin/bash

set -e

e() {
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}$1${NC}"
    eval "$1"
}

GEM_NAME="omniauth-slack-openid"
VERSION=$(grep -e 'VERSION = .*' lib/omniauth/slack_openid/version.rb | sed -e "s/.*'\(.*\)'.*/\1/")
GEM_FILE="$GEM_NAME-$VERSION.gem"

e "gem build $GEM_NAME.gemspec"
e "gem push $GEM_FILE"

