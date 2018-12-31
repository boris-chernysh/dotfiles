#!/bin/bash

FORMAT=%Y%m%d%H%M%S
USERNAME=$(secret-tool lookup sftp login)
HOST=$(secret-tool lookup sftp host)
FOLDER=$(secret-tool lookup sftp folder)
PROTOCOL=http
PASSWORD=$(secret-tool lookup sftp pass)
FILENAME=$(date +$FORMAT).png
TMP_DIR=/tmp
FILEPATH="$TMP_DIR/$FILENAME"
FILEURL="$PROTOCOL://$HOST/$USERNAME/$FILENAME"

escrotum -s $FILEPATH \
	&& pinta $FILEPATH \
	&& sshpass -p $PASSWORD sftp $USERNAME@$HOST:$FOLDER <<< "put $FILEPATH" \
	&& echo $FILEURL | xsel --clipboard \
	&& DISPLAY=:0 notify-send "$FILEURL uploaded successfully"

if [ -f $FILEPATH ]; then
	rm $FILEPATH
fi
