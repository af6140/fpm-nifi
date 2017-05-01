#!/bin/sh

export NIFI_HOME=${NIFI_HOME-/opt/nifi}
export NIFI_PID_DIR=${NIFI_PID_DIR-/var/run}
export NIFI_LOG_DIR=${NIFI_LOG_DIR-/var/log/nifi}

echo "Setting NIFI_HOME: ${NIFI_HOME}"
echo "Setting NIFI_PID_DIR: ${NIFI_PID_DIR}"
echo "Setting NIFI_LOG_DIR: ${NIFI_LOG_DIR}"
