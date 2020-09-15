#!/usr/bin/env bash

set -e
set -o pipefail

mapfile -t urls < <( curl -fsSL https://pypi.org/pypi/dm.xmlsec.binding/json | jq -r '.releases | .[] | map(.url) | reduce .[] as $url ([]; $url)' )

for url in ${urls[@]}
do
    echo $url
    curl -fsSL $url | tar zxv
    cd dm.xmlsec.binding*
    version=$(grep '^Version' PKG-INFO | cut -d ' ' -f 2)
    mv * .. && cd ..
    git add .
    git commit -m "$version"
    git tag "$version"
    rm -rf ./* # no hidden files
done
