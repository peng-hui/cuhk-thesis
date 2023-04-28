#!/bin/bash -x

ROOT=$(git rev-parse --show-toplevel)
TMPD=$(mktemp -d /tmp/latexdiff.XXXXXXXXXX)
HERE=$(realpath $(pwd))
TEMPLATE_DIR=~/project/paper-template # Change this to the path of your local paper-template
TEMPLATE_DIR=$(realpath $TEMPLATE_DIR)

mkdir -p $TMPD

OLD_REPO=$TMPD/old

git clone "$ROOT" $OLD_REPO

cd $OLD_REPO
git checkout $1

NEWD=$ROOT
OLDD=$OLD_REPO

cd $OLDD
cp -rf $TEMPLATE_DIR/bin .
python bin/symlink.py
make

cd "$NEWD"
latexdiff --flatten $OLDD/p.tex p.tex > diff.tex
# compile diff.tex in $OLDD might encounter missing citations due to the updates in p.bib
make MAIN=diff
rm -f diff.tex
