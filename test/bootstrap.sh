#!/usr/bin/env bash

yum install -y java-1.8.0-openjdk-devel
yum localinstall -y /vagrant/pkg/nifi*1.2.0*.rpm
sleep 5
systemctl enable nifi
systemctl start nifi