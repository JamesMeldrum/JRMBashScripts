#!/usr/bin/env python
# encoding: utf-8
"""
searchreplace.py

Created by Jonathan Chu on 2009-10-31.
Copyright (c) 2009 exhibit-E. All rights reserved.


Usage:

Search Only
$ python searchreplace.py search_text
$ python searchreplace.py 'search text'

Search and Replace
$ python searchreplace.py search_text replace_text
$ python searchreplace.py 'search text' 'replace text'

Examples:

Search Only
$ python searchreplace.py Lorem
$ python searchreplace.py 'Lorem Ipsum'

Search and Replace
$ python searchreplace.py Lorem Ipsum
$ python searchreplace.py old_script.js new_script.js
"""
__version__ = '0.1'

import os, sys, fileinput, glob, types, re, itertools
from optparse import OptionParser

# set a local path for testing
my_local_path = '/Users/jonathan/projects/test/'
local_path = '/Users/jonathan/ee_websites/'

# svn path
svn_sites_root = '/var/siteupdate/svn/'

# set this temporarily
# path = my_local_path
# path = local_path
path = svn_sites_root

def find_files():
	"""
	find files in directory and subdirectories 
	"""
	if not os.access(path, os.R_OK):
		raise ScriptError("cannot access path: '%s'" % path)
	
	file_list = []
	
	try:
		for directory, subdirs, files in os.walk(path):
			if '.svn' in subdirs:
				subdirs.remove('.svn')
			file_list.extend(['%s%s%s' % (directory, os.sep, f) for f in files])

	except Exception, e:
		raise ScriptError(str(e))
	
	return file_list


def search(stext):
	"""
	search inside file_list for search term 'stext'
	"""
	file_list = find_files()
	result = dict()
	exclude_list = ['.jpg','.swf','.png','.gif','.ai','.psd','.fla']
	
	try:
		search_terms = []
		search_terms.append(re.compile(stext).search)
		for file in file_list:
			if os.path.exists(file):
				file_ext = os.path.splitext(file)
				if file_ext[1] in exclude_list:
					pass
				else:
					fhandle = open(file, 'r')
					fcontent = fhandle.read()
					fhandle.close()
					lines = zip(itertools.count(1), fcontent.splitlines())
					for s in search_terms:
						lines = filter(lambda t: s(t[1]), lines)
						if not lines:
							break
					else:
						if lines:
							result[file] = '\n'.join(["Line %d: %s" % t for t in lines])
		
	except Exception, e:
		raise ScriptError(str(e))
	
	return result


def replace(stext, rtext):
	""" 
	replace stext with rtext in directory and subdirectories using search
	"""
	file_list = find_files()
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
	

def print_results(results):
	count = 0
	for f in sorted(results):
		sys.stdout.write("%s\n%s\n---\n" % (f, results[f]))
		count += 1
	sys.stdout.write("\nSummary\n--------\n# of files: %s\n" % count)


def svn_commit(dirs, msg):
	"""
	commit all files to svn that were modified by replace method
	"""
	files_commited = 0
	
	try:
		for name in dirs:
			change_dir = '%s' % name
			os.chdir(change_dir)
			# print change_dir
			commit_msg = "svn commit -m \"%s\"" % msg
			os.system(commit_msg)
			# print commit_msg
	
	except Exception, e:
		raise ScriptError(str(e))
	
	return files_commited


def confirm(response):
	"""
	confirm the raw_input of user
	"""
	if not response:
		return False
	response = response.lower()
	if response in ['y', 'yes']:
		print "You answered '%s'. The script will continue to execute..." % response
		return True
	elif response in ['n', 'no']:
		print "You answered '%s'. The script will now abort..." % response
		return False
	else:
		print "I didn't understand '%s'. Please specify '(y)es' or (n)o'." % response


def find_dirs(results):
	"""
	find the top level directories for the given path and return full path
	"""
	dir_list = []
	
	for files in results:
		print "%s" % files
		dir_list.append(os.path.dirname(files))	
	
	return dir_list


class ScriptError(Exception):
	pass

def main():
	p = OptionParser("usage: searchreplace.py search_text replace_text")
	p.add_option('-c','--commit',dest='commit',
				 help="COMMIT all changes",
				 metavar="COMMIT")
	(options, args) = p.parse_args()
	if len(args) < 1:
		p.error("must specify a search argument")
	
	stext = args[0]
	
	if len(args) == 1:
		try:
			search_list = search(stext)
			print_results(search_list)
		except KeyboardInterrupt:
			print 'Abort...'
	elif len(args) == 2:
		try:
			rtext = args[1]
			search_list = search(stext)
			print_results(search_list)
			
			response = raw_input('Would you like to make these modifications?\n--> ')

			if confirm(response):
				replace_list = replace(stext, rtext)
				print replace_list, "modification(s)."
				
				message = raw_input('Please enter a commit message:\n--> ')
				print "Committing files..."
				# print search_list
				dir_list = find_dirs(search_list)
				# print "\n\n"
				# print dir_list
				svn_commit(dir_list, message)
			
		except KeyboardInterrupt:
			print 'Abort...'


if __name__ == '__main__':
	main()