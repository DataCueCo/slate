#!/bin/bash
git fetch upstream
git checkout master
git merge upstream/master
git checkout dc-theme
git merge master
