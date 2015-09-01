#!/bin/bash 
KEY_PATH="/etc/openvpn/easy-rsa/keys"
SCR_PATH="/etc/openvpn/easy-rsa"
OVPN_SAMPLE="../client.ovpn"

if [ -z "$1" ]
	then echo -n "Enter new client name: "
	read -e USER
else
	USER=$1
fi

if [ -z "$USER" ]
	then echo "You must enter client name"
	exit
fi

{
	eval "${SCR_PATH}/build-key $USER"
	touch "$USER.ovpn"
	cat "$OVPN_SAMPLE" >> "$USER.ovpn"
	ca=$( cat ${KEY_PATH}/ca.crt )
	printf "\n<ca>\n$ca\n</ca>\n" >> "$USER.ovpn"
	crt=$( cat ${KEY_PATH}/${USER}.crt )
	printf "\n<cert>\n$crt\n</cert>\n" >> "$USER.ovpn"
	key=$( cat ${KEY_PATH}/${USER}.key )
	printf "\n<key>\n$key\n</key>\n" >> "$USER.ovpn"
} || {
	echo "There was a problem"
}

