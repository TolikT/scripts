#!/bin/bash

#Задание:
#Написать скрипт на языке shell, который выводит списки:
#пользователей, принадлежащих указанной группе.

GROUP_ID=$(getent group "$1" | awk -F: '{print $3}');
{
	getent group | awk -F: "{if (\$1 == \"$1\") print \$4}" | tr ',' '\n';
	getent passwd | awk -F: "{if (\$4 == $GROUP_ID) print \$1}";
} | sort -u | sed '/^$/d'