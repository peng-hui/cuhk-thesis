#!/bin/bash -x

ROOT=$(git rev-parse --show-toplevel)
TMPD=$(mktemp -d /tmp/latexdiff.XXXXXXXXXX)
HERE=$(realpath $(pwd))
TEMPLATE_DIR=~/project/paper-template # Change this to the path of your local paper-template
TEMPLATE_DIR=$(realpath $TEMPLATE_DIR)

mkdir -p $TMPD

OLD_REPO=$TMPD/old

git clone "${ROOT}" "${OLD_REPO}"

cd "${OLD_REPO}"
git checkout $1

pip install arxiv-latex-cleaner # For cleanning comments and user-defined commands
#  arxiv_latex_cleaner is only compatible with Python >=3
arxiv_latex_cleaner "${OLD_REPO}"
arxiv_latex_cleaner "${ROOT}"

NEWD="${ROOT}_arXiv"
OLDD="${OLD_REPO}_arXiv"

cd $OLDD
cp -rf $OLD_REPO/code .
cp -rf $OLD_REPO/p.bib .
cp -rf $TEMPLATE_DIR/bin .
python bin/symlink.py
make
latexdiff --flatten p.tex "${NEWD}/p.tex" > diff.tex

make MAIN=diff
cp -f diff.pdf "${ROOT}/diff.pdf"
rm -rf "${NEWD}"
