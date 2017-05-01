#!/bin/sh

GROUPNAME=nifi
USERNAME=nifi
HOMEDIR=/opt/nifi
getent group ${GROUPNAME} >/dev/null || groupadd -r ${GROUPNAME}
getent passwd ${USERNAME} >/dev/null || \
    useradd -r -g ${GROUPNAME} -d ${HOMEDIR} -s /sbin/nologin \
    -c "Apache Nifi User" ${USERNAME}

exit 0