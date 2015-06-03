#!/bin/bash

#Задание:
#Написать программу, выдающую список пользователей, имеющих право исполнения заданного файла.

if [[ ! -f "$1" ]]
	then
		echo "Object isn't file or file not found."
	else
	RIGHTS_STRING=$(ls -l "$1" | awk '{print $1}')
	OWNER_STRING=$(ls -l "$1" | awk '{print $3}')
	GROUP_STRING=$(ls -l "$1" | awk '{print $4}')
	GROUP_ID=$(ls -n "$1" | awk '{print $4}')
	THOSE_CAN_LAUNCH=""
	if [[ ${RIGHTS_STRING:3:1} = "x" ]]
		then
			THOSE_CAN_LAUNCH="$OWNER_STRING"
	fi
	if [[ ${RIGHTS_STRING:6:1} = "x" ]]
		then
			THOSE_CAN_LAUNCH_SECONDARY=$(getent group | gawk -F[:,] "BEGIN {ORS=\" \"} {if (\$1==\"$GROUP_STRING\") {for (i=4;i<=NF;i++) {if (\$i!=$OWNER_STRING) {print \$i}}}}")					
			THOSE_CAN_LAUNCH_PRIMARY=$(getent passwd | awk -F: "{if (\$4 == \"$GROUP_ID\" && \$1 != \"$OWNER_STRING\") print \$1} ")
			THOSE_CAN_LAUNCH="$THOSE_CAN_LAUNCH $THOSE_CAN_LAUNCH_SECONDARY $THOSE_CAN_LAUNCH_PRIMARY"			
	fi
	if [[ ${RIGHTS_STRING:9:1} = "x" ]]
		then
			USERS1=$(getent group | awk -F: "{if (\$1 == \"$GROUP_STRING\") print \$4}" | tr ',' ' '| tr '\n' ' ')
			USERS2=$(getent passwd | awk -F: "{if (\$4 == \"$GROUP_ID\") print \$1}"| tr '\n' ' ')
   			THOSE_CAN_LAUNCH_TEMP=$(echo "$(getent passwd | awk -F: "{if (\$1 != $OWNER_STRING) print \$1}") $USERS1 $USERS2" | tr ' ' '\n' | sort | uniq -u | tr '\n' ' ')
			THOSE_CAN_LAUNCH="$THOSE_CAN_LAUNCH $THOSE_CAN_LAUNCH_TEMP"				
	fi
	echo $THOSE_CAN_LAUNCH | tr ' ' '\n' | sort -u
fi
