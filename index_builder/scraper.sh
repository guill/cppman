#!/bin/bash
set -e
echo "Getting cppreference mirror ip"

MIRROR_IP=`getent hosts cppreference_mirror | awk '{ print $1 }'`
echo "IP is $MIRROR_IP. Adding to hosts file"
echo "$MIRROR_IP en.cppreference.com" >> /etc/hosts

cd /cppman_root/bin

echo "Wating for the webserver to start up"
until $(curl --output /dev/null --silent --head --fail http://cppreference_mirror:80); do
    sleep 5
done

echo "Rebuilding index"
# Rebuild the index
./cppman -r

echo "Done Rebuilding index"
cp /root/.config/cppman/index.db /cppman_root/cppman/lib/index.db
echo "Copied to the cppman/lib folder."
