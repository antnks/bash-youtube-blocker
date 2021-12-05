#!/bin/bash

sed /youtube/s/^[#]*// -i /etc/hosts
systemctl stop apache2
systemctl disable apache2

PID=`ps aux | grep firefox$ | awk '{ print $2 }'`
if [ ! -z "$PID" ]
then
	kill "$PID"
fi

