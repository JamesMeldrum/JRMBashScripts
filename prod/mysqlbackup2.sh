#!/bin/bash
#
# 080812rq

HOWNICE=5

DAYSTOKEEP=34			# how many days of backups shall we keep?

MYSQL_BIN="/usr/bin/mysql"
MYSQL_DUMP="/usr/bin/mysqldump"
MYSQL_USER="root"	# user with SELECT & LOCK TABLE privilages
MYSQL_PASS="9TQ4PVKXWDE3WWGG"
MYSQL_DATA_DIR="/var/lib/mysql/"

OUTDIR="/home/ryan/mysql_bax"     # where backups go

DATESTAMP=`date +"%Y%m%d%H%M"`
TMPDIR="$OUTDIR/tmp-$DATESTAMP"

mkdir -p $TMPDIR

for db in `$MYSQL_BIN --silent -u root -p$MYSQL_PASS --execute="SHOW Databases" mysql`; do
	$MYSQL_DUMP --single-transaction -u$MYSQL_USER -p$MYSQL_PASS $db > $TMPDIR/$db.sql
done

cd $TMPDIR
time -p nice -n $HOWNICE tar zcf $OUTDIR/mysql-$DATESTAMP.tar.gz *
rm -rf $TMPDIR

#backup to dev
scp $OUTDIR/mysql-$DATESTAMP.tar.gz gm@dev.exhibit-e.com:~/dal-db2/

x=$DAYSTOKEEP
for file in `ls -ltA $OUTDIR | grep -e '^-' | awk '{print $9}'`; do
	if [ $x -lt 1 ]; then
		rm -f $OUTDIR/$file
	fi
	((x-=1))
done