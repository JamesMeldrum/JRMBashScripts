#!/usr/bin/env python
# encoding: utf-8
"""
startsite.py

Install:
sudo cp /path/to/startproject.py /usr/local/bin/

If necessary:
chown $USER /usr/local/bin/startsite.py
chmod a+x /usr/local/bin/startsite.py

Usage:
startsite.py SITENAME

Created by Jonathan Chu on 2011-01-31.
Copyright (c) 2011 exhibit-E. All rights reserved.

"""
__version__ = '0.1'

import os
import re
import shutil
import stat
import sys


def copy_site(pathname, name):
    """
    Copies the site layout template into the current working directory.

    """
    top_dir = os.path.join(pathname, name)

    os.mkdir(top_dir)
    home = os.path.expanduser('~')
    template_dir = os.path.join(home, 'ee_bash/dev/site_template')

    if not os.path.exists(template_dir):
        print "Please make sure ", os.path.join(home, 'ee_bash/dev/site_templates'), " exists."
        sys.exit()

    for d, subdirs, files in os.walk(template_dir):
        relative_dir = d[len(template_dir)+1:].replace('site_name', name)
        if relative_dir:
            os.mkdir(os.path.join(top_dir, relative_dir))
        for subdir in subdirs[:]:
            if subdir.startswith('.'):
                subdirs.remove(subdir)
        for f in files:
            path_old = os.path.join(d, f)
            path_new = os.path.join(top_dir, relative_dir, f.replace('site_name', name))
            fp_old = open(path_old, 'r')
            fp_new = open(path_new, 'w')
            fp_new.write(fp_old.read().replace('{{ site_name }}', name))
            fp_old.close()
            fp_new.close()
            try:
                shutil.copymode(path_old, path_new)
            except OSError:
                sys.stderr.write(style.NOTICE("Notice: Couldn't set permission bits on %s. You're probably using an uncommon filesystem setup. No problem.\n" % path_new))


def main():
	if len(sys.argv) < 1:
            p.error("You must specify a site name.")
	    sys.exit(0)

	name = sys.argv[1]
	pathname = os.getcwd()

	if not os.path.exists(name):
            copy_site(pathname, name)
            print "Site '%s' created at: %s\n" % (name, pathname)
            print 'Be sure to check that the Configuration.php and httpd settings are correct.'
        else:
            print "Site '%s' already exists. Aborting..." % name


if __name__ == '__main__':
	main()
