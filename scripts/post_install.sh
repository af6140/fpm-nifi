#!/bin/sh
USERNAME=nifi
GROUPNAME=nifi
chown -R ${USERNAME}:${GROUPNAME} /opt/nifi

if [ -d /var/lib/nifi ]; then
 chown -R ${USERNAME}:${GROUPNAME} /var/lib/nifi
fi

if [ -d /var/log/nifi ]; then
 chown -R ${USERNAME}:${GROUPNAME} /var/log/nifi
fi

if [ -d /var/run/nifi ]; then
 chown -R ${USERNAME}:${GROUPNAME} /var/run/nifi
fi