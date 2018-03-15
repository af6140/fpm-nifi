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

if [ -d /var/lib/nifi/work ]; then
  chown -R ${USERNAME}:${GROUPNAME} /var/lib/nifi/work
fi

if [ -d /var/lib/nifi/tmp ]; then
  chown -R ${USERNAME}:${GROUPNAME} /var/lib/nifi/tmp
fi

if [ -d /opt/nifi/flow ]; then
  chown -R ${USERNAME}:${GROUPNAME} /opt/nifi/flow
fi

if [ -f /opt/nifi/bin/nifi.sh ]; then
  chmod 755 /opt/nifi/bin/nifi.sh
fi

if [ -f /opt/nifi/bin/nifi-env.sh ]; then
  chmod 755 /opt/nifi/bin/nifi-env.sh
fi

if [ -d /usr/lib/tmpfiles.d ]; then
  echo "d /var/run/nifi 0755 nifi nifi -" > /usr/lib/tmpfiles.d/nifi.conf
fi

exit 0
