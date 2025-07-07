#!/bin/bash

# Determine the active network interface
ACTIVE_INTERFACE=$(ip route | awk '/default/ {print $5}' | head -n1)

if [ -z "$ACTIVE_INTERFACE" ]; then
    echo "{\"text\": \"  Disconnected\", \"tooltip\": \"No active network connection\"}"
    exit 0
fi
    

# Get the interface type (ethernet or wifi)
INTERFACE_TYPE=$(nmcli -t -f DEVICE,TYPE device status | grep "^$ACTIVE_INTERFACE:" | cut -d: -f2)

# Get general information

# Get the IP address
IP_ADDRESS=$(ip -4 addr show "$ACTIVE_INTERFACE" | awk '/inet/ {print $2}' | cut -d/ -f1)
# Get the CIDR notation
CIDR=$(ip -4 addr show "$ACTIVE_INTERFACE" | awk '/inet/ {print $2}' | cut -d/ -f2)
# Get the default gateway
GATEWAY=$(ip route | awk '/default/ {print $3}' | head -n1)
# Get DHCP Hostname
DHCP_HOSTNAME=$(nmcli device show "$ACTIVE_INTERFACE" | grep IP4.DHCP_HOSTNAME | awk '{print $2}')
# Get DHCP Domain
DOMAIN=$(nmcli device show "$ACTIVE_INTERFACE" | grep IP4.DOMAIN | awk '{print $2}')
DNS=$(nmcli device show "$ACTIVE_INTERFACE" | grep IP4.DNS | awk '{print $2}')

# Get WI-Fi specific information
ESSID=""
SIGNAL_STRENGTH=""
if [ "$INTERFACE_TYPE" = "wifi" ]; then
    # Get ESSID
    ESSID=$(nmcli -t -f active,ssid dev wifi | grep "^yes" | cut -d: -f2)
    # Get Signal Strength
    SIGNAL_STRENGTH=$(nmcli -t -f active,signal dev wifi | grep "^yes" | cut -d: -f2)
fi

# Format text and tooltip
TEXT=""
TOOLTIP=""
if [ -n "$DHCP_HOSTNAME" ]; then
    TEXT="$DHCP_HOSTNAME"
    TOOLTIP="Interface: $ACTIVE_INTERFACE\n\nDomain: $DOMAIN"
elif [ -n "$DOMAIN" ]; then
    TEXT="$DOMAIN"
    TOOLTIP="Interface: $ACTIVE_INTERFACE\n"
else
    TEXT="$ACTIVE_DEVICE"
fi
TOOLTIP+="\nIP4/CIDR: $IP_ADDRESS/$CIDR\\nGateway: $GATEWAY\\nDNS: $DNS"

# Output JSON for Waybar
if [ "$INTERFACE_TYPE" = "wifi" ]; then
    echo "{\"text\": \"   $ESSID ($TEXT)\", \"tooltip\": \"Signal Strength: $SIGNAL_STRENGTH%\\n\\n$TOOLTIP\"}"
elif [ "$INTERFACE_TYPE" = "ethernet" ]; then
    echo "{\"text\": \"  $TEXT\", \"tooltip\": \"$TOOLTIP\"}"
else
    echo "{\"text\": \"  UNDEFINED interface type active\"}"
fi
