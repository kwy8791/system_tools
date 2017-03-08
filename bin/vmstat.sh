#!/bin/sh

vmstat 1 2 |tail -1 > /tmp/vmstat_$$.log
# CPU割当待ち
RUN_QUEUE=`awk '{print $1}' /tmp/vmstat_$$.log`

# I/O 待ち
BIO_QUEUE=`awk '{print $2}' /tmp/vmstat_$$.log`

# CPU user
CPU_USER=`awk '{print $13}' /tmp/vmstat_$$.log`

# CPU system
CPU_SYS=`awk '{print $14}' /tmp/vmstat_$$.log`

# CPU IOwait
CPU_IO=`awk '{print $16}' /tmp/vmstat_$$.log`

# CPU CPUwait
CPU_CPU=`awk '{print $17}' /tmp/vmstat_$$.log`
