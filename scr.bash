#!/bin/bash

typeset file_Name;

function Error
{
	if [[ ! $1 == 0 ]]
        	then printf "\nОшибка! Смотри журнал ошибок.\n\n";
        fi
}

function Tilda
{
	file_Name=$1;
	if [[ "${file_Name:0:2}" == "~/" ]]
		then
			file_Name="$HOME${file_Name:1}";
	elif [[ "${file_Name:0:3}" == "\\~/" ]]
		then
			file_Name="${file_Name:1}";
	fi
}

if [[ ! -a "Error.log" ]] 
	then touch "Error.log"
fi

exec 2>>Error.log;  # stderr -> ErrorLog

### Main menu ###
printf "Список команд:\n";
printf "1) Напечатать имя текущего каталога;\n2) Создать файл;\n3) Отменить доступ к файлу для всех остальных пользователей;\n";
printf "4) Сменить права доступа к файлу для владельца файла;\n5) Переименовать файл;\n6) Выйти из программы.\n";
printf "Введите номер команды:\n";

OIFS=$IFS
IFS=
while read -r command
do               
	case "$command" in

	### pwd ###

	1)		printf "\n"; 
			pwd;
                	Error $?;
			printf "\n";
	;;
	
	### touch ###

	2)		printf "Введите имя файла или полный путь к нему, если не хотите создавать его в текущей директории:\n";
			read -r filename;
			Tilda "$filename";
			filename="$file_Name";
			touch -- "$filename";
			Error $?;
	;;

	### delete permissions for other users ###
	### chmod o-rwx ###

	3)		printf "Введите имя файла или полный путь к нему:\n";
			read -r filename;
			Tilda "$filename";
			filename="$file_Name";
			if ([[ -a "$filename" ]] && [[ -f "$filename" ]])
				then
					chmod  -- o-rwx "$filename";
                			Error $?;
			else printf "\nНеудача\n\n";
			fi			
	;;

	### change permissions for user with menu ###

	4)		printf "Введите имя файла или полный путь к нему.\n";
			read -r filename;
			Tilda "$filename";
			filename="$file_Name";
			if ([[ -f "$filename" ]] && [[ -a "$filename" ]])
				then
					while :
					do
						printf "Выберите вариант из предложенного списка:\n"
						printf "1 - Добавить права на чтение;\n2 - Добавить права на запись;\n3 - Добавить права на выполнение;\n"	
						printf "4 - Удалить права на чтение;\n5 - Удалить права на запись;\n6 - Удалить права на выполнение;\n"	
						printf "7 - Выйти из данного меню.\n"
						read -r answer;
						case "$answer" in
							1) chmod -- u+r "$filename"
							   Error $?;
							;;
							2) chmod -- u+w "$filename"
							   Error $?;
							;;
							3) chmod -- u+x "$filename"
							   Error $?;
							;;
							4) chmod -- u\-r "$filename"
							   Error $?;
							;;
							5) chmod -- u\-w "$filename"
							   Error $?;
							;;
							6) chmod -- u\-x "$filename"
							   Error $?;
							;;
							7) break;;
							*) printf "\nОшибка! Неверный выбор.\n\n";;
						esac
					done
			else printf "\nНеудача\n\n";
			fi
	;;

	### rename file ###

	5)		printf "Введите имя изменяемого файла или полный путь к нему:\n";
			read -r filename;
			Tilda "$filename";
			filename="$file_Name";
			printf "Введите новое имя файла:\n";
			read -r name;
			Tilda "$name";
			name="$file_Name";
			if [[ -d "$name" ]]
				then printf "\n"$name" является каталогом\n\n";
			elif [[ -a "$name" ]]
				then printf "\nФайл "$name" уже существует\n\n";
			else 	 		
				mv -- "$filename" "$name";
                		Error $?;
			fi
	;;

	### exit ###

        6)      exit;  
		Error $?;
	;;

	### impossibility ###

	*)	printf "\nНеизвестная команда. Номера команд принадлежат диапазону 1-6.\n\n";
	;;
	esac
	printf "Список команд:\n";
        printf "1) Напечатать имя текущего каталога;\n2) Создать файл;\n3) Отменить доступ к файлу для всех остальных пользователей;\n";
        printf "4) Сменить права доступа к файлу для владельца файла;\n5) Переименовать файл;\n6) Выйти из программы.\n";
	printf "Введите номер команды:\n"; 
done
IFS=$OIFS
