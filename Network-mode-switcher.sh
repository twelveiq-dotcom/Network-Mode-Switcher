#!/bin/bash

systemctl stop NetworkManager
systemctl stop wpa_supplicant

read -p "Network Interface: " network_interface
read -p "MAC Address: " mac_address
read -p "Mode(managed/monitor): " mode

ip link set dev $network_interface down

if [[ "$mac_address" == "" ]];
then
	echo "Default MAC Address."
else
	ip link set dev $network_interface address $mac_address
fi	

iwconfig $network_interface mode $mode

systemctl restart NetworkManager
systemctl restart wpa_supplicant

ip link set dev $network_interface up
