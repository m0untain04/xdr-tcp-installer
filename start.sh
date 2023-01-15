#!/bin/bash
# ------------------------------------------------------------------------
# 					starter for xdr-tcp installer
#
# 	Copyright (C) 2020-2021 Mihnea Stoicescu (aka MCS FM DX, m0untain)
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  Special thanks to: kkonradpl
#
# ------------------------------------------------------------------------
# Variables (CONFIG)

PORT="7373"
PASSWORD="1234"
MAXUSERS="1"
DIR="/home/xdrd-master"
# Functions./xdrd -t 5550 -u 1 -p 123
# You can add more functions by yourself if you want !
function startServer {
	if [ -d $DIR ]; then
		cd $DIR
		if [ -f "xdrd" ]; then
			screen -dmS xdr-tcp ./xdrd -t $PORT -u $MAXUSERS -p $PASSWORD 
			echo "Server started !"
		else
			echo "Error: XDRD executable not found !"
		fi
	else
		echo "Error: XDRD folder not found !"
	fi
}

function stopServer {
	CHECK=`ps u -C xdrd | grep -vc USER`
	if [ $CHECK -eq 0 ]; then
		echo "XDRD Server is currently not running."
	else
		killall $EXEC
		echo "XDRD Server stopped !"
	fi
}

function serverStatus {
	CHECK=`ps u -C xdrd | grep -vc USER`
	if [ $CHECK -eq 0 ]; then
		echo "XDRD Server is currently not running."
	else 
		echo "XDRD Server is running."
	fi
}

case "$1" in
	start)
		startServer
		;;

	stop)
		stopServer
		;;

	restart)
		stopServer
		sleep 1
		startServer
		;;

	status)
		serverStatus
		;;


	*)
		echo "Syntax: $0 [start|stop|restart|status]"
		exit 1
		;;
		
esac
exit
