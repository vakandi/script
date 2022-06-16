BACKUPNAME='backup-$RANDOM-2022-piscine.tar'
cd
tar cvf $BACKUPNAME .zshrc .oh-my-zsh piscine Desktop Documents Downloads Applications
echo "Uploading the backup to transfer.sh...."
echo ".....\n"
curl --upload-file ./$BACKUPNAME https://transfer.sh/backup-3320-2022-piscine.tar
echo "\nFinished."
