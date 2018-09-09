#!/bin/bash
set -e
echo "Fetching latest archive info"

# Download the latest cppreference archive if it isn't already downloaded
LATEST_ARCHIVE_DATE=`wget -q -O - https://en.cppreference.com/w/Cppreference:Archives | sed -n "s/^.*File:cppreference-doc-\([^\.]*\)\.zip.*$/\1/p"`
echo "Latest archive date is $LATEST_ARCHIVE_DATE"
DATA_FOLDER="cppreference-doc-${LATEST_ARCHIVE_DATE}"
ARCHIVE_FILENAME="${DATA_FOLDER}.tar.xz"

mkdir -p /index_builder/cache
if [ ! -f /index_builder/cache/${ARCHIVE_FILENAME} ]; then
	echo "Downloading ${ARCHIVE_FILENAME}"
	wget -q -O /index_builder/cache/${ARCHIVE_FILENAME} http://upload.cppreference.com/mwiki/images/c/cb/${ARCHIVE_FILENAME}
	echo "Extracting ${ARCHIVE_FILENAME}"
	mkdir -p $DATA_FOLDER
	tar -xf /index_builder/cache/${ARCHIVE_FILENAME} --directory /index_builder/cache
fi

cd /index_builder/cache/${DATA_FOLDER}/reference/en.cppreference.com
echo "Hosting data on port 80"
python3 -m http.server 80
