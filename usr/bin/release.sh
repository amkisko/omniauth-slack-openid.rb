#!/bin/bash

set -e

e() {
    GREEN='\033[0;32m'
    NC='\033[0m'
    echo -e "${GREEN}$1${NC}"
    eval "$1"
}

GEM_NAME="omniauth-slack-openid"
VERSION=$(grep -Eo "VERSION\s*=\s*'.+'" lib/omniauth/slack_openid.rb | grep -Eo "[0-9.]{5,}")
GEM_FILE="$GEM_NAME-$VERSION.gem"

e "gem build $GEM_NAME.gemspec"
e "gem push $GEM_FILE"

e "git tag $VERSION && git push --tags"
