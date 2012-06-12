#!/bin/bash 

mkdir ~/tweenlite_tmp
cd ~/tweenlite_tmp/
curl -O http://www.greensock.com/ActionScript/TweenLite/TweenLite.zip
curl -O http://www.greensock.com/ActionScript/TweenLite/TweenFilterLite.zip

curl -O http://www.greensock.com/ActionScript/TweenLiteAS3/TweenLiteAS3.zip
curl -O http://www.greensock.com/ActionScript/TweenFilterLiteAS3/TweenFilterLiteAS3.zip

unzip TweenLite.zip
unzip TweenFilterLite.zip
unzip TweenLiteAS3.zip
unzip TweenFilterLiteAS3.zip

mv -f TweenLite/gs/OverwriteManager.as /Users/ryan/ee_websites/as_libs/as2/gs/
mv -f TweenLite/gs/TweenLite.as /Users/ryan/ee_websites/as_libs/as2/gs/
mv -f TweenLite/gs/TweenGroup.as /Users/ryan/ee_websites/as_libs/as2/gs/
mv -f TweenFilterLite/gs/TweenFilterLite.as /Users/ryan/ee_websites/as_libs/as2/gs/
mv -f TweenLite/gs/easing/* /Users/ryan/ee_websites/as_libs/as2/gs/easing/

mv -f TweenLiteAS3/gs/OverwriteManager.as /Users/ryan/ee_websites/as_libs/as3/gs/
mv -f TweenLiteAS3/gs/TweenLite.as /Users/ryan/ee_websites/as_libs/as3/gs/
mv -f TweenLiteAS3/gs/TweenGroup.as /Users/ryan/ee_websites/as_libs/as3/gs/
mv -f TweenFilterLiteAS3/gs/TweenFilterLite.as /Users/ryan/ee_websites/as_libs/as3/gs/
mv -f TweenLiteAS3/gs/easing/* /Users/ryan/ee_websites/as_libs/as3/gs/easing/

cd /Users/ryan/ee_websites/as_libs
svn status --show-updates