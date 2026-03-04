#!/bin/bash
set -e

git branch -m trunk master
git fetch origin
git branch -u origin/master master
git remote set-head origin -a
