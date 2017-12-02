#!/bin/sh -e
if [ "${TRAVIS_PULL_REQUEST_SLUG}" == "" ];
then
  echo "Cannot release docs without TRAVIS_PULL_REQUEST_SLUG set"
  exit 1;
fi
REPO="https://github.com/${TRAVIS_PULL_REQUEST_SLUG}"

rm -rf docs
git clone -b gh-pages --single-branch $REPO ./docs
cd docs
git pull origin gh-pages
cd ..

DEST="master"

if [ "${TRAVIS_TAG}" != "" ];
then
  DEST="${TRAVIS_TAG}"
  # change the default page to the latest
  echo "<meta http-equiv='refresh' content='0; url=/Parse-SDK-JS/api/${DEST}'>" > "docs/api/index.html"
fi

npm run docs

mkdir -p "docs/api/${DEST}"
cp -R out/* "docs/api/${DEST}"
