#!/bin/bash
###########################################################################################
#
# This tool is used to release system cached memory
# if CPU load is high or cached memory is large.
#
###########################################################################################

# If load > CPU_NUM/2, clean cache.
CPU_NUM=`cat /proc/cpuinfo | grep "processor" | wc -l`
MAX_SYS_LOAD_NUM=`expr $CPU_NUM / 2`
if [ "$MAX_SYS_LOAD_NUM" = "0" ]; then
    MAX_SYS_LOAD_NUM=1
fi
SYS_LOAD_NUM=`uptime | awk '{print $(NF-2)}' | sed 's/,//'`

# If cache > TOTAL_RAM/5, clean cache.
TOTAL_RAM=`free -g| grep Mem|awk '{print $2}'`
MIN_RAM=`expr $TOTAL_RAM / 5`
if [ "$MIN_RAM" = "0" ]; then
    MIN_RAM=1
fi
CACHE_MEM=`free -g| grep Mem|awk '{print $7}'`

if [ `echo "$SYS_LOAD_NUM > $MAX_SYS_LOAD_NUM"|bc` -eq 1 ] ||  [ `echo "$CACHE_MEM > $MIN_RAM"|bc` -eq 1 ]; then
    if [ `pgrep drop_caches | wc -l` -gt 0 ]; then
        echo  $(date +"%y-%m-%d %H:%M:%S") " Cleaning process is running"
    else
        echo $(date +"%y-%m-%d") `uptime`
        echo $(date +"%y-%m-%d") `free -g`
        echo $(date +"%y-%m-%d %H:%M:%S") " Start to clean cache";
        echo 1 > /proc/sys/vm/drop_caches
        echo $(date +"%y-%m-%d %H:%M:%S") " End to clean cache";
        echo $(date +"%y-%m-%d") `uptime`
        echo $(date +"%y-%m-%d") `free -g`
    fi
fi
