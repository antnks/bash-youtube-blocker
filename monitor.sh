#!/bin/bash

LAST="last.txt"
COUNT="count.txt"
KILLSWITCH="killswitch.txt"
EMAIL="root@localhost"
XAUTH="/home/username/.Xauthority"

while true
do

	# killswitch fully disables any actions taken
	if [ -f "$KILLSWITCH" ]
	then
		#echo "killswitch"
		sleep 5
		continue
	fi

	# check if the day passed - reset count, unblock
	today=`date "+%Y%m%d"`
	last=$(<$LAST)

	if [ "$today" != "$last" ]
	then
		# no reset allowed until 12:00
		hour=`date '+%H'`
		if [ "$hour" -lt 12 ]
		then
			#echo "too early"
			sleep 5
			continue
		fi

		echo "new day $today, reset"
		echo "$today" > $LAST
		echo 0 > $COUNT
		./unblock.sh
		echo RESET | mail -s YOUTUBE_BLOCKER $EMAIL
	fi

	# check if already blocked - continue
	isunblocked=`grep ^#.*youtube.* /etc/hosts`
	if [ -z "$isunblocked" ]
	then
		#echo "blocked"
		sleep 5
		continue
	fi

	TITLE=`env DISPLAY=:0 XAUTHORITY=$XAUTH wmctrl -l -p | grep YouTube`
	RDDCPU=`top -b -n 1 | grep RDD | awk '{ print $9 }'`

	echo "TITLE: $TITLE RDDCPU: $RDDCPU"

	count=$(<$COUNT)
	if [ -z "$count" ]
	then
		count=0
	fi

	# if title found and rddcpu not eq 0.0 - count++
	if [ ! -z "$TITLE" ] && [ "$RDDCPU" != "0,0" ] && [ "$RDDCPU" != "0.0" ]
	then
		if [ "$count" == "0" ]
		then
			echo START | mail -s YOUTUBE_BLOCKER $EMAIL
		fi

		echo "count=$count"
		count=$((count+1))
		echo "$count" > $COUNT
	else
		echo "nop, count: $count"
	fi

	# if count is over - block, echo time to blocked
	if [ "$count" -gt 720 ]
	then
		echo "Time to block"
		./block.sh
		echo BLOCKED | mail -s YOUTUBE_BLOCKER $EMAIL
	fi

	sleep 5

done

