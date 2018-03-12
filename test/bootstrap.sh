#!/usr/bin/env bash

yum install -y java-1.8.0-openjdk-devel
yum localinstall -y /vagrant/pkg/nifi-*-1.5.0-*.rpm
sleep 2
systemctl enable nifi
sleep 2
systemctl start nifi