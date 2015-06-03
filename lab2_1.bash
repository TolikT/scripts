#!/bin/bash

#Задание:
#Написать скрипт на языке shell, который выводит списки:
#имён файлов в текущем каталоге, являющихся косвенными ссылками на указанный файл. Список отсортировать по времени создания;

gfind . -maxdepth 1 -lname "${1:?'Файл не задан'}" -print0 | gxargs -r0 ls -tbc | cut -c 3-



