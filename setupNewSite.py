#!/usr/bin/env python 


# Dates:
	# 6/6/2012 - Creation
	# 6/12/2012 - Ensured it was working, added goals

## TODO:
	# Check for dependencies:
		# SVN
		# ~/sites
		# ln -s ~/sites /var/www/sites/
	# Add line to /etc/hosts
	# Add line to apache conf

	# Split JenkinsProjectImporter into:
		# JenkinsProjectImporter
		# ArgParser
		# JenkinsProjectCheckout

	# Investigate
import os
import sys
from subprocess import call

class JenkinsProjectCheckout:
  pass

class ArgParser:
  pass

class JenkinsProjectImporter:
 
  def __init__(self):
    self.parseArgs()
    self.assignConfVars()
    self.processInstruction()
#    self.checkoutRepo()

  def assignConfVars(self):
    self.targetRepo = self.getRepoName()
    self.conf = {
		  'website_source_dir':str(os.environ['HOME'])+'/sites',
		  'svn_protocol':'svn+ssh://',
		  'svn_repo':'svn@svn.exhibit-e.biz/',
		  'svn_command_list':'svn ls ',
		  'svn_command_clone':'svn co '
		}
  def parseArgs(self):
    self.args=sys.argv
    if len(self.args) <= 2:
      print 'USAGE: '+sys.argv[0]+' [options] [site]' 
      sys.exit(1)
    else:
      self.repoFn = self.getRepoFn()      
    return

  def getRepoName(self):
    return self.args[2]

  def getRepoFn(self):
    return self.args[1]

  def getRepoList(self):
    call(['svn','ls','svn+ssh://svn@svn.exhibit-e.biz/'+self.targetRepo+'/trunk/'])
    sys.exit(0)

  def coRepo(self):
    call(['svn','co','svn+ssh://svn@svn.exhibit-e.biz/'+self.targetRepo+'/trunk/',self.conf['website_source_dir']+'/'+self.targetRepo])
    sys.exit(0)

  def processInstruction(self):
    if self.repoFn == 'co':
	self.coRepo()
    elif self.repoFn == 'ls':
	self.getRepoList()
    else:
	print self.repoFn
	print '\n'
	print self.args
	print 'Only arguements \'co\' and \'ls\' are supported at the moment'
	sys.exit(1)

#  def checkoutRepo():

if __name__ == "__main__":
  newImporter = JenkinsProjectImporter()
