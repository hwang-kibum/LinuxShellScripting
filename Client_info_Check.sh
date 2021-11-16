#!/bin/bash

#Line number printing
#set -x

#debug
export PS4='+$LINENO:$FUNCNAME:'

#Debug COMMAND Line print
#trap '(read -p "[$LINENO] $BASH_COMMAND?")' DEBUG

clear
DATE=`date`
echo [DATE] : $DATE
HWDATE=`hwclock`
echo [HWCLOCK] : $HWDATE
USER_CRRENT_ID=`whoami`
USER_SHELL=`echo $$`
TTY=`tty`
echo [USER_CRRENT_ID] : $USER_CRRENT_ID
echo [USER_SHELL] : $USER 
echo [TTY] : $TTY
echo "=============================<CPU INFO>================================="
CPU_INFO=`dmidecode -t processor | grep Version | tail -n1 | cut -d ':' -f2`
CPU_CORE=`dmidecode -t processor | grep -i "Core Count" | tail -n1 | cut -d ':' -f2`
declare -i CPU_LOGICAL_CORE=`cat /proc/cpuinfo | grep processor | tail -n1 | cut -d ':' -f2`
echo [CPU_NAME] : $CPU_INFO
echo [PHYSICAL_Core] :$CPU_CORE

#CPU Core Count Start 0 ...n+1
CPU_LOGICAL_CORE=CPU_LOGICAL_CORE+1
echo [LOGICAL_CORE] : $CPU_LOGICAL_CORE
#CPU_used...
echo " "

echo "============================<MEMORY INFO>==============================="
declare -i MEMORY_INFO=`cat /proc/meminfo | grep MemTotal | cut -d ':' -f2 | awk '{print $1}'`
MEMORY_INFO=MEMORY_INFO/1024
echo [MEMORY_INFO] : $MEMORY_INFO MB

declare -i FREE=`cat /proc/meminfo | grep MemFree | cut -d ':' -f2 | awk '{print $1}'`
FREE=FREE/1024
echo [MEM_FREE] : $FREE MB

declare -i AVAILABLE=`cat /proc/meminfo | grep MemAvailable | cut -d ':' -f2 | awk '{print $1}'`
AVAILABLE=AVAILABLE/1024
echo [AVAILABLE] : $AVAILABLE MB

declare -i CACHED=`cat /proc/meminfo | grep ^Cached | cut -d ':' -f2 | awk '{print $1}'`
CACHED=CACHED/1024
echo [CACHED] : $CACHED MB

declare -i SWAP=`cat /proc/meminfo | grep SwapTotal | cut -d ':' -f2 | awk '{print $1}'`
SWAP=SWAP/1024
echo [SWAP_TOTAL] : $SWAP MB
SWAP=`cat /proc/meminfo | grep SwapFree | cut -d ':' -f2 | awk '{print $1}'`
SWAP=SWAP/1024
echo [SWAP_FREE] : $SWAP MB
echo " "

echo "==========================<OS VERSION INFO>============================="
OS=`cat /etc/*-release | tail -n1`
BITS=`getconf LONG_BIT`
echo [OS_VERSION] : $OS
echo [BIT] : $BITS bit
echo " "


echo "=======================<PACKAGE VERSION INFO>==========================="
JAVA=`java --version`
echo [JAVA_VERSION] : $JAVA
POSTGRESQL=`psql --version`
echo [POSTGRESQL] : $POSTGRESQL
echo " "

echo "===========================<SELINUX INFO>==============================="
#cp /etc/sysconf/seliux /etc/sysconf/selinux.bak
PERMISSIVE="permissive"
SELINUX=`sestatus | grep -i "Current mode" | cut -d ':' -f2 | sed 's/^ *//'`
echo $SELINUX
if [[ $SELINUX = "permissive" ]]; then
	echo config completed.
	
else
	setenforce 0
	SELINUX=`sestatus | grep -i "Current mode" | cut -d ':' -f2 | sed 's/^ *//'`
	echo setting Completed.
fi
echo [CURRENT_SELINUX] : $SELINUX

SELINUXFILE1=`cat /etc/sysconfig/selinux | grep -i "^SELINUX=" | cut -d'=' -f2 | cut -d'=' -f2`
echo $SELINUXFILE1
if [[ $SELINUX_FILE1_Before = $PERMISSIVE ]]; then 
	echo [SELINUX_FILE1_Before] : $SELINUXFILE1
else
	sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/sysconfig/selinux
	SELINUXFILE2=`cat /etc/sysconfig/selinux | grep -i "^SELINUX=" | cut -d'=' -f2 | cut -d'=' -f2`
	echo [SELINUX_FILE2_After] : $SELINUXFILE2
fi
echo " "



echo "===========================<PROCESS INFO>==============================="
echo [JAVA]
echo `ps -ef | grep java`
echo [Postgresql]
echo `ps -ef | grep postgres`
echo " "


echo "===========================<fdisk -l INFO>==============================="
DEV_DISK1=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sda" | cut -d ':' -f1`
DEV_DISK2=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sdb" | cut -d ':' -f1`
DEV_DISK3=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sdc" | cut -d ':' -f1`
DEV_DISK4=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sdd" | cut -d ':' -f1`
DEV_DISK5=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sde" | cut -d ':' -f1`
SIZE1=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sda" | cut -d ':' -f2`
SIZE2=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sdb" | cut -d ':' -f2`
SIZE3=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sdc" | cut -d ':' -f2`
SIZE4=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sdd" | cut -d ':' -f2`
SIZE5=`fdisk -l | grep -i "^Disk " | grep -i "/dev/sde" | cut -d ':' -f2`
echo [DEV_DISK_1] : ${DEV_DISK1:-" "} ${SIZE1:-"null"}
echo [DEV_DISK_2] : ${DEV_DISK2:-" "} ${SIZE2:-"null"}
echo [DEV_DISK_3] : ${DEV_DISK3:-" "} ${SIZE3:-"null"}
echo [DEV_DISK_4] : ${DEV_DISK4:-" "} ${SIZE4:-"null"}
echo [DEV_DISK_5] : ${DEV_DISK5:-" "} ${SIZE5:-"null"}
echo " "


echo "=============================<df -h INFO>================================="
TITLE=`df -h | head -n1`
echo "  "[TITLE] : $TITLE
ROOT=`df -h | grep /$`
echo "   "[ROOT] : $ROOT

VAR=`df -h | grep var&`
echo "    "[VAR] : $VAR

BOOT=`df -h | grep /boot$`
echo "   "[BOOT] : $BOOT

USR=`df -h | grep /usr$`
echo "    "[USR] : $USR

CODERAY=`df -h | grep /CODERAY`
echo [CODERAY] : $CODERAY
echo " "


echo "==============================<Firewall Log>==============================="
DB=5432
WEB=28443
DBPORT=`firewall-cmd --zone=public --list-all | grep "^  ports:" | grep 5432 | cut -d':' -f2 | cut -d'/' -f1 | cut -d' ' -f2`
WEBSSL=`firewall-cmd --zone=public --list-all | grep "^  ports:" | grep 28443 | cut -d'/' -f2 | cut -d' ' -f2`
if [ ${DBPORT} = ${DB} ]; then
	echo good ${DBPORT}
else 
	firewall-cmd --zone=public --permanent --add-port=5432/tcp
fi
#firewall-cmd --zone=public --permanent --add-port=5432/tcp
if [ ${WEBSSL} = ${WEB} ]; then
	echo good ${WEBSSL}
else
	firewall-cmd --zone=public --permanent --add-port=28443/tcp
fi
#firewall-cmd --zone=public --permanent --add-port=28443/tcp
firewall-cmd --reload
FIREWALL=`firewall-cmd --zone=public --list-all | grep "ports" |  grep tcp`
echo [FIREWALL] : $FIREWALL
echo " "

#echo "==============================<System Log>================================="
#ERROR=`cat /var/log/messages | grep error`
#PENDDING=`cat /var/log/messages | grep pendding`
#FAIL=`cat /var/log/messages | grep fail`
#echo [ERROR] Log
#cat /var/log/messages | grep error
#echo " "

#echo [PENDDING] log
#cat /var/log/messages | grep pendding
#echo " "

#echo [FAIL] log
#cat /var/log/messages | grep fail
#echo " "
exit 0
