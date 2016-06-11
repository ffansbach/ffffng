#!/usr/bin/env bash

set -e

function confirm() {
    msg="$1 [y/n] "

    echo -n $msg

    while read -n1 c; do
        echo

        if [ "$c" == "y" ]; then
            return 0
        fi

        if [ "$c" == "n" ]; then
            return 1
        fi

        echo -n $msg
    done
}

cd $(dirname $0)

version=$(grep '^ *"version": *"[^"]*" *, *$' package.json | cut -d '"' -f4)
npm_tag=$1

if [ -z "$version" ]; then
    echo "Could not determine current version."
    exit 1
fi

if [ -z "$npm_tag" ]; then
    npm_tag=latest
fi

echo "Current version: $version#$npm_tag"

if [[ $version =~ 'SNAPSHOT' ]]; then
    echo "Will not publish SNAPSHOT version."
    exit 1
fi

echo

if confirm "Continue publishing?"; then
    ./node_modules/.bin/grunt clean build

    cd dist
    npm publish -t $npm_tag
fi

