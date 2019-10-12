#!/bin/bash

rm -rf out || exit 0;
mkdir out;

GH_REPO="@github.com/$TRAVIS_REPO_SLUG.git"

FULL_REPO="https://$GH_TOKEN$GH_REPO"

git config --global user.name "Aaron Jacobs"
git config --global user.email "atheriel@gmail.com"

make

cd out
git init
git add .
git commit -m "Updated GitHub pages."
git push --force --quiet $FULL_REPO master:gh-pages
