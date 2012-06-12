#!/usr/bin/env python
# encoding: utf-8
"""
startproject.py

Install:
sudo cp /path/to/startproject.py /usr/local/bin/

If necessary:
chown $USER /usr/local/bin/startproject.py
chmod a+x /usr/local/bin/startproject.py

Usage:
startproject.py PROJECTNAME

Created by Jonathan Chu on 2009-12-10.
Copyright (c) 2009 exhibit-E. All rights reserved.

"""
__version__ = '0.2'

import os, sys, fileinput, glob

def find_files(path):
	"""
	find files in directory and subdirectories
	"""
	if not os.access(path, os.R_OK):
		raise ScriptError("cannot access path: '%s'" % path)

	file_list = []

	try:
		for directory, subdirs, files in os.walk(path):
			file_list.extend(['%s%s%s' % (directory, os.sep, f) for f in files])

	except Exception, e:
		raise ScriptError(str(e))

	return file_list

def replace(stext, rtext, path):
	"""
	replace stext with rtext in directory and subdirectories using find_files
	"""
	file_list = find_files(path)
	files_changed = 0

	try:
		for line in fileinput.input(file_list, inplace=1):
			if stext in line:
				line = line.replace(stext, rtext)
				files_changed += 1
			sys.stdout.write(line)

	except Exception, e:
		raise ScriptError(str(e))

	return files_changed

class ScriptError(Exception):
	pass

def main():
	if len(sys.argv) < 1:
		p.error("You must specify a project name")
		sys.exit(0)

	projectname = sys.argv[1]
	pathname = os.getcwd()
	if not os.path.exists(projectname):
	    os.makedirs(projectname)
	    os.chdir(projectname)
	    os.makedirs('common')
	    os.makedirs('project_files')
	    os.makedirs('site')

	    # writing httpd-dev.conf
	    filename = 'httpd-dev.conf'
	    file = open(filename, 'w')
	    file.write("<VirtualHost *:80>\nDocumentRoot /var/www/ee_websites/PROJECTNAME/site\nServerName PROJECTNAME.dev\nCustomLog /var/www/logs/PROJECTNAME.site.log \"combined\"\nphp_flag magic_quotes_gpc Off\n\nRewriteEngine On\n\nRewriteRule ^/(.*\.)v[0-9.]+\.(css|js|gif|png|jpg|swf)$ /$1$2 [L,E=VERSIONED_FILE:1,PT]\nHeader add \"Expires\" \"Mon, 28 Jul 2014 23:30:00 GMT\" env=VERSIONED_FILE\nHeader add \"Cache-Control\" \"max-age=315360000\" env=VERSIONED_FILE\n\nRewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f\nRewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d\nRewriteRule ^/([^/]+)/?([^/]+)?/?([^/]+)?/?([^/]+)?/?$  /index.php?mode=$1&var1=$2&var2=$3 [L,QSA]\n\n</VirtualHost>")
	    file.close()

	    # writing httpd-site.conf
	    filename = 'httpd-site.conf'
	    file = open(filename, 'w')
	    file.write("<VirtualHost *>\nDocumentRoot /opt/www/PROJECTNAME/site\nServerName www.PROJECTNAME.com\nServerAlias PROJECTNAME.com\nCustomLog $PROJECTNAME \"combined\"\nphp_flag magic_quotes_gpc Off\n\nRewriteEngine On\n\nRewriteCond %{HTTP_HOST}\t\t!^www.PROJECTNAME.com [NC]\nRewriteRule ^/(.*)\t\t\t\thttp://www.PROJECTNAME.com/$1 [R=301,L]\n\nRewriteRule ^/(.*\.)v[0-9.]+\.(css|js|gif|png|jpg|swf)$ /$1$2 [L,E=VERSIONED_FILE:1,PT]\n\nRewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f\nRewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d\nRewriteRule ^/([^/]+)/?([^/]+)?/?([^/]+)?/?([^/]+)?/?$\t/index.php?mode=$1&var1=$2&var2=$3 [L,QSA]\n\n</VirtualHost>")
	    file.close()

	    # writing 'common' stuff
	    os.chdir('common')
	    os.makedirs('Configuration')
	    os.makedirs('includes')
	    filename = 'Configuration.php'
	    file = open(filename, 'w')
	    file.write("<?php\n$Configuration['db_database']\t\t\t\t\t= '';\n$Configuration['db_username']\t\t\t\t\t= '';\n$Configuration['db_password']\t\t\t\t\t= '';\n\n$Configuration['site_name']\t\t\t\t\t\t= '';\nif (PRODUCTION) {\n\t$Configuration['client_url']\t\t\t\t= 'http://www.PROJECTNAME.com/';\n} else {\n\t$Configuration['client_url']\t\t\t\t= 'http://PROJECTNAME.dev';\n}\n\n$Configuration['mailinglist_sender']\t\t\t= '';\n$Configuration['mailinglist_reply']\t\t\t\t= '';")
	    file.close()

	    # writing schema.sql
	    os.chdir('../project_files')
	    filename = 'schema.sql'
	    file = open(filename, 'w')
	    file.write("-- --------------------------------------------------------\n\n--\n-- Database: `PROJECTNAME`\n--\n\n-- --------------------------------------------------------")
	    file.close()

	    # writing site stuff
	    os.chdir('../site')
	    os.makedirs('img')
	    os.makedirs('js')
	    os.makedirs('templates')
	    filename = 'index.php'
	    file = open(filename, 'w')
	    file.write("<?php\ndefine ('EE_SITE', 'PROJECTNAME');\nrequire(getenv('ee_libs') . 'libeestd3.php');\nrequire(EE_LIBS . 'Smarty/Smarty.class.php');\n\nrequire(COMMON_DIR . '/Configuration.php');\n\nfunction &Smarty_init()\n{\n\t$sm = getSmarty();\n\t$sm->assign('mode', $_GET['mode']);\n\n\treturn $sm;\n}\n\nfunction home()\n{\n\n}\n\n########################################################################\n## RUN FORREST, RUN! NAMED HER THE ONLY NAME I COULD THINK OF; JENNY\n########################################################################\n\nif (is_GET('mode')) {\n\t$mode = $_GET['mode'];\n} else {\n\t$mode = $_GET['mode'] = 'home';\n}\n\nswitch($mode) {\n\tcase 'home':\n\t\thome();\n\t\tbreak;\n\n\tdefault:\n\t\trequire(EE_LIBS . '404.php');\n}\n\n")
	    file.close()

	    # robots.txt
	    filename = 'robots.txt'
	    file = open(filename, 'w')
	    file.write("User-agent: *\nDisallow:")
	    file.close()

	    # style.css
	    filename = 'style.css'
	    file = open(filename, 'w')
	    file.write("/*---------------------------------\n\tsite style goes here\n---------------------------------*/")
	    file.close()

	    # search and replace 'PROJECTNAME' with user specified projectname
	    os.chdir('../')
	    path = os.getcwd()
	    stext = 'PROJECTNAME'
	    rtext = projectname
	    replace(stext, rtext, path)
	    print "Project '%s' created at: %s\n" % (projectname, path)
	    print 'Be sure to check that the Configuration.php and httpd settings are correct.'

if __name__ == '__main__':
	main()
