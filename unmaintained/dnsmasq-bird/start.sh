#!/bin/sh
[ -f "/etc/bird-static.conf" ] && /usr/sbin/bird -f &
/usr/sbin/dnsmasq -d $@