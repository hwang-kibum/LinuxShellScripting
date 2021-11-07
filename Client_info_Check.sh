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
CPU_INFO=`dmidecode -t processor | grep Version | tail -n1 | cut -d ':' -f2`
CPU_CORE=`dmidecode -t processor | grep -i "Core Count" | tail -n1 | cut -d ':' -f2`
declare -i CPU_LOGICAL_CORE=`cat /proc/cpuinfo | grep processor | tail -n1 | cut -d ':' -f2`
echo "=============================<CPU INFO>================================="
echo [CPU_NAME] : $CPU_INFO
echo [PHYSICAL_Core] :$CPU_CORE

#CPU Core Count Start 0 ...n+1
CPU_LOGICAL_CORE=CPU_LOGICAL_CORE+1
echo [LOGICAL_CORE] : $CPU_LOGICAL_CORE
#CPU_used...
echo " "
echo " "

echo "============================<MEMORY INFO>==============================="
MEMORY_INFO=`cat /proc/meminfo | grep MemTotal | cut -d ':' -f2 | awk '{print $1}'`
echo [MEMORY_INFO] : $MEMORY_INFO 
FREE=`cat /proc/meminfo | grep MemFree | cut -d ':' -f2 | awk '{print $1}'`
echo [MEM_FREE] : $FREE
AVAILABLE=`cat /proc/meminfo | grep MemAvailable | cut -d ':' -f2 | awk '{print $1}'`
echo [AVAILABLE] : $AVAILABLE
CACHED=`cat /proc/meminfo | grep ^Cached | cut -d ':' -f2 | awk '{print $1}'`
echo [CACHED] : $CACHED

SWAP=`cat /proc/meminfo | grep SwapTotal | cut -d ':' -f2 | awk '{print $1}'`
echo [SWAP_TOTAL] : $SWAP
SWAP=`cat /proc/meminfo | grep SwapFree | cut -d ':' -f2 | awk '{print $1}'`
echo [SWAP_FREE] : $SWAP
echo " "
echo " "

echo "==========================<OS VERSION INFO>============================="
OS=`cat /etc/*-release | tail -n1`
BITS=`getconf LONG_BIT`
echo [OS_VERSION] : $OS
echo [BIT] : $BITS bit
echo " "
echo " "


echo "=======================<PACKAGE VERSION INFO>==========================="
JAVA=`java --version`
echo [JAVA_VERSION] : $JAVA
POSTGRESQL=`psql --version`
echo [POSTGRESQL] : $POSTGRESQL


echo "===========================<PROCESS INFO>==============================="
echo ps -ef | grep java


echo "=============================<CPU INFO>================================="
echo "=============================<CPU INFO>================================="
echo "=============================<CPU INFO>================================="

