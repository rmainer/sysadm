#!/bin/bash
set -e

# config
date=`date -I`
dir=backup_wiki_${date}
wikidb=wikidb
wikiuser=wikiuser
wikipassword=wikipassword

# check for root 
if [ `id -u` != 0 ]; then
	echo "Become root!"
	exit 0
fi

# create temporary backup directory
cd /tmp
rm -rf backup_wiki_*
mkdir ${dir}
cd ${dir}

# cp LocalSettings.php and images
cp -a /etc/mediawiki/LocalSettings.php .
cp -a /var/lib/mediawiki/images .
cp -a /var/lib/mediawiki/resources/assets/logo.png .

# mariadb dump
mysqldump ${wikidb} --user=${wikiuser} --password=${wikipassword} > ${wikidb}.sql

# create tar archive
cd ..
tar cf ${dir}.tar ${dir}
bzip2 -9 ${dir}.tar
mv ${dir}.tar.bz2 /home/rm/backup/wiki
chown rm:rm /home/rm/backup/wiki/${dir}.tar.bz2

# cleanup
rm -rf /tmp/${dir}
