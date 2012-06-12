#!/usr/bin/env python
# encoding: utf-8
"""
recursiveTabToSpace.py

Created by Ryan Quigley on 2010-09-01.
Copyright (c) 2010 exhibit-E. All rights reserved.

"""
__version__ = '0.1'

import os, sys, fileinput, glob, types, re, itertools
from optparse import OptionParser

# set a local path for testing
path = './'

def getFiles():
    """
    find files in directory and subdirectories 
    """
    if not os.access(path, os.R_OK):
        raise ScriptError("cannot access path: '%s'" % path)
    
    file_list = []

    for directory, subdirs, files in os.walk(path):
        if '.svn' in subdirs:
            subdirs.remove('.svn')
        file_list.extend(['%s%s%s' % (directory, os.sep, f) for f in files])
    
    return file_list


class ScriptError(Exception):
    pass

def main():
    try:
        file_list = getFiles()
        include_list = ['.js','.php','.css','.html']

        for file in file_list:
            if os.path.exists(file):
                file_ext = os.path.splitext(file)
                if file_ext[1] in include_list:
                    cmd = 'expand -t 4 ' + file + ' > ' + file + '.tmp && mv -f ' + file + '.tmp ' + file
                    os.system(cmd)

    except KeyboardInterrupt:
        print 'Abort...'


if __name__ == '__main__':
    main()