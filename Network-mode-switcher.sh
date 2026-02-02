#!/bin/bash

systemctl stop NetworkManager
systemctl stop wpa_supplicant

read -p "Network Interface: " network_interface
read -p "MAC Address: " mac_address
read -p "Mode(managed/monitor): " mode
network_interface_mon="${network_interface}mon"

if [[ "$mac_address" == "" ]]; then
	echo "Default MAC address."
fi

ip link set dev $network_interface down 2>/dev/null
ip link set dev $network_interface_mon down 2>/dev/null

if [[ "$mode" == "monitor" ]]; then
	iw dev $network_interface interface add $network_interface_mon type monitor
        if [[ "$mac_address" != "" ]]; then
	        ip link set dev $network_interface_mon address $mac_address
	fi
	ip link set $network_interface_mon up
elif [[ "$mode" == "managed" ]]; then
        ip link set dev $network_interface_mon down 2>/dev/null
       	iw dev $network_interface set type $mode
        if [[ "$mac_address" != "" ]]; then
	        ip link set dev $network_interface address $mac_address
	fi
	iw dev $network_interface_mon del 2>/dev/null
	ip link set $network_interface up
	systemctl start NetworkManager wpa_supplicant
fi
