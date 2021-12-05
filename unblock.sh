#!/bin/bash

sed /youtube/s/^/#/ -i /etc/hosts
systemctl start apache2
systemctl enable apache2

