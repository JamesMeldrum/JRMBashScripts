#!/bin/bash

# Collects dotfiles from your home directory, updates git repo and pushes it if 
# its necessary

find "~/Code" -type d -maxdepth 1 -exec git status {} \;
