#!/bin/bash

HOSTED="https://your.any.url/that/has/killswitch.txt"

lock="/root/youtube/killswitch.txt"
killswitch=`curl -s $HOSTED | head -n 1`
isunblocked=`grep ^#.*youtube.* /etc/hosts`

# place a lock when killswitch must override monitoring
if [ "$killswitch" == "1" ] || [ "$killswitch" == "0" ]
then
	echo "$killswitch" > "$lock"
else
	rm -f "$lock"
fi

exit 0

if [ "$killswitch" == "1" ] && [ ! -z "$isunblocked" ]
then
	/root/youtube/block.sh

elif [ "$killswitch" == "0" ] && [ -z "$isunblocked" ]
then
	/root/youtube/unblock.sh

else
	:
	#echo UNKNOWN
fi

