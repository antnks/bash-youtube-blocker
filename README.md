# bash-youtube-blocker

A simple Youtube blocker for Linux written in bash

## Prerequisites

* Linux
* Firefox browser
* wmctrl
* A teenager that needs to control Youtube screen time

## Install

Create a dir `/root/youtube` and copy `*.sh` files there.

Put `minutely.sh` into cron:
```
* * * * * /root/youtube/minutely.sh
```

Add this to autostart (ex, rc.local):
```
cd /root/youtube
screen -L -d -m ./monitor.sh
```

## Usage

The script manages `/etc/hosts` file and points youtube domain names to loopback to block access.

The default screen time is starting from 12:00 and limitted to 1 hour of active watching.

