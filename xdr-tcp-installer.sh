#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "This script can be runned only by sudo or root !"
  exit
fi
clear
echo "XDR-TCP Installer by Mihnea Stoicescu (aka MCS FM DX, m0untain)"
echo "This script currently works only with Ubuntu."
read -p "Press enter to start the installation process..."
# ------------------------------------------------------------------------
echo "Installing packages..."
sleep 3
	echo "Updating..."
	sudo apt update &> /dev/null
	echo "Done ! Installing apache2..."
	sudo apt install apache2 -y &> /dev/null
	echo "Done ! Installing wget..."
	sudo apt install wget -y &> /dev/null
	echo "Done ! Installing icecast2..."
	sudo apt install icecast2 -y &> /dev/null
	echo "Done ! Installing ffmpeg..."
	sudo apt install ffmpeg -y &> /dev/null
	echo "Done ! Installing unzip..."
	sudo apt install unzip -y &> /dev/null
	echo "Done ! Installing openssl..."
	sudo apt install openssl -y &> /dev/null
	echo "Done ! Installing gcc..."
	sudo apt install gcc -y &> /dev/null
	echo "Done ! Installing libraries..."
	sudo apt install libssl-dev -y &> /dev/null
	echo "Done ! Installing make..."
	sudo apt install make -y &> /dev/null
clear
echo "Packages installed ! Downloading XDR TCP..."
	cd /home
	wget https://github.com/kkonradpl/xdrd/archive/master.zip  &> /dev/null
	unzip master.zip  &> /dev/null
	rm master.zip  &> /dev/null
	cd xdrd-master
echo "XDR-TCP has a function where it cannot be runned using user root ! "
echo "If you want to disable this feature, type yes. If not, type no"
read input
if [ $input == "yes" ]; then
echo " "
echo "Modifying file..."
	sed -i -e 162d -e 163d -e 164d -e 165d -e 166d /home/xdrd-master/xdrd.c
echo " "
echo "Done ! Compiling..."
	make -f Makefile  &> /dev/null
	gcc -o xdrd xdrd.o -lpthread -lcrypto
elif [ $input == "no" ]; then
	make -f Makefile  &> /dev/null
	gcc -o xdrd xdrd.o -lpthread -lcrypto
fi
echo " "
echo "Configuring..."
cd /etc/systemd/system
touch xdr-tcp.service
echo "
[Unit]
Description=XDR-TCP Service
# After=network.target
# After=systemd-user-sessions.service
# After=network-online.target

[Service]
# User=spark
# Type=simple
# PIDFile=/run/my-service.pid
ExecStart=/home/xdrd-master/start.sh start
ExecStop=/home/xdrd-master/start.sh stop
[Install]
WantedBy=multi-user.target
	" > xdr-tcp.service
echo " "
echo "Start XDR-TCP on system boot ? [Yes/No]"
read input
	if [ $input == "yes" ]; then
	systemctl enable xdr-tcp.service
	echo " "
	echo "Startup on boot enabled ! Continuing..."
elif [ $input == "no" ]; then echo "Continuing..."
fi
echo " "
echo "Downloading config file..."
cd /home/xdrd-master
wget https://raw.githubusercontent.com/m0untain04/xdr-tcp-installer/main/start.sh
clear 
echo " "
rm README.md
rm xdr-protocol.h
rm xdrd.o
rm xdrd.c
rm Makefile
echo "XDR TCP has been downloaded and installed !"
echo "To start the server, first configure start.sh located in /home/xdrd-master"
echo "Then execute ./start.sh in directory /home/xdrd-master or you can use systemctl start xdr-tcp.service"
read -p "Press enter to finish the installation process..."
# END OF SCRIPT
