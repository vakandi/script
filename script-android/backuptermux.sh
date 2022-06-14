#!/bin/sh
SIZE=$(ls -lhF /storage/emulated/0/utiles/termuxbackup/termux-backup.tar.gz | cut -c 28-32)
DATE=$(stat /storage/emulated/0/utiles/termuxbackup/termux-backup.tar.gz |grep Modify | cut -c -24 | cut -c 8-)

BACKUPFILE=/storage/self/primary/utiles/termuxbackup/termux-backup.tar.gz
echo "Size of the last backup: \n\033[1;34m $SIZE\033[0m\nLast Backup: \033[1;34m $DATE \033[0m\n"
read -p " Are you sure you want to backup now and erase the old one?  (y/n)?" CONT
if [ "$CONT" = "y" ]; then
	echo "......"
	echo "...."
	echo ".."
	echo "."
	tar -zvcf $BACKUPFILE -C /data/data/com.termux/files ./home ./usr
	echo "\033[1;32m:::::::::::::::::\033[0m"
	echo "\033[1;32m:::BACKUP DONE:::\033[0m"
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m::::REFRESHING:::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m:::::SLEEP 30s:::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	sleep 30
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m::::: $SIZE :::::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
	echo "\033[1;32m::::::DONE:::::::\033[0m";
	echo "\033[1;32m:::::::::::::::::\033[0m";
else
	echo "\033[1;33mNo backup was made\033[0m"
	echo "The last Backup at \033[1;34m $DATE \033[0m has not been touched"
	echo "Exit..";
fi
