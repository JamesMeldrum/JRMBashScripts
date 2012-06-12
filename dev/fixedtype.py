#!/usr/bin/env python
# encoding: utf-8
"""
fixedtype.py

Searches a defined path for the culprits that use the old way of declaring
fixed type in yaml files and prints the full file path of the match

The regex will look for:

        type: select
        options:
            projects: Press
        visible: false

Usage:

    $ python fixedtype.py

Example:

    $ python fixedtype.py
    /Users/jonathan/projects/test/matthewmarks/common/Configuration/artists.yaml
    /Users/jonathan/projects/test/matthewmarks/common/Configuration/artists_object.yaml
    /Users/jonathan/projects/test/matthewmarks/common/Configuration/fairs_object.yaml

"""

import os, sys, re

path = '/var/siteupdate/svn/'
pattern = r'''type:\sselect\n(\s*options:)\n(\s*([\w]*:\s[\w]*\n))(\s*visible:\sfalse)'''

def find_pattern(filepath):
    p = re.compile(pattern, re.MULTILINE)
    data = open(filepath).read()
    if p.search(data):
        print filepath

def find_files(dummy, dirs, files):
    for file in files:
        if '.yaml' == os.path.splitext(file)[1] and os.path.isfile(dirs + '/' + file):
            find_pattern(dirs + '/' + file)

class ScriptError(Exception):
	pass

def main():
    if not os.access(path, os.R_OK):
        raise ScriptError("cannot access path: '%s'" % path)

    os.path.walk(path, find_files, 3)

if __name__ == '__main__':
    main()
