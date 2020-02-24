#!/bin/sh
/usr/sbin/bird -f &
/usr/local/sbin/dnsmasq -d $@