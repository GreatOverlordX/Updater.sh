#!/bin/bash
# run as root if not root.
if (( $EUID != 0 )); then
	sudo $0
	exit
fi
apt update # sudo apt update
echo
echo "-->>> Upgrading Packages . . ."
apt -y upgrade # sudo apt upgrade -y
echo
echo "-->>> Upgrading Distro Packages . . ."
apt -y dist-upgrade # sudo apt dist-upgrade -y
echo
apt clean # Cleaning
echo "-->>> Performing Autoremove"
apt -y autoremove # sudo apt autoremove -y
dpkg --list | grep "^rc"
if [[ $? -eq 0 ]]
then echo
	echo "-->>> Purging Old Config Files!"
	dpkg --list | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge
fi
if [[ `du -m /var/log/syslog | cut -f1` -gt 99 ]]
then echo "-->>> syslog is over 100MB"
	echo "-->>> logs can be rotated using the following command:"
	echo
	echo sudo logrotate -f /etc/logrotate.conf
	echo
	echo "-->>> Allow me to assist you with that, please!"
	logrotate -f /etc/logrotate.conf
fi
echo "Process Complete!"

