#!/bin/bash

export TZ=America/Sao_Paulo

DATE=$(date '+%d-%m-%Y %H:%M:%S')

if systemctl is-active --quiet httpd; then
	STATUS="Online"
	MESSAGE="O serviço Apache está funcionando normalmente."
	FILENAME="apache_online.txt"
else
	STATUS="Offline"
	MESSAGE="O serviço Apache não está funcionando normalmente."
	FILENAME="apache_offline.txt"
fi

echo "$DATE httpd $STATUS - $MESSAGE" | sudo tee -a /mnt/nfs/$FILENAME
