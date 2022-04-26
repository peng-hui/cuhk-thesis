#!/usr/bin/env python

import os, sys, shutil

TEMPLATE_DIR="~/submission/paper-template" # Change this to the path of your local paper-template

LINKS = ["bin", "Makefile", "conf.bib", "data/color", "lab.bib", "sty"]

TEMPLATE_DIR = os.path.expanduser(TEMPLATE_DIR)
PWD = os.getcwd()
if PWD[-4:] == "/bin":
    os.chdir("..")
    PWD = os.getcwd()

if PWD == TEMPLATE_DIR:
    print("Warning! You are attempting to create symbolic links in the template directory!!!")
    sys.exit(1)

if not os.path.isdir(TEMPLATE_DIR):
    print("Warning! Your TEMPLATE_DIR setting is incorrect!!!")
    sys.exit(1)

for l in LINKS:
    src = os.path.join(TEMPLATE_DIR, l)
    dst = os.path.join(PWD, l)
    is_dir = os.path.isdir(src)
    print(src)
    try:
        if is_dir:
            shutil.rmtree(dst)
        else:
            os.remove(dst)
    except OSError as e:
        print(e)
    try:
        os.symlink(src, dst)
    except OSError as e:
        print(e)

IGNORE_LIST = ["/" + l for l in LINKS]
with open(".gitignore", "r") as f:
    ignored_entries = f.read().split('\n')
    for e in ignored_entries:
        if e in IGNORE_LIST:
            IGNORE_LIST.remove(e)

with open(".gitignore", "a") as f:
    for l in IGNORE_LIST:
        f.write(l + "\n")
