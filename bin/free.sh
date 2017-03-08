#!/bin/sh

# free -m
free -m > /tmp/free_$$.txt

# Total Mem
MEM_TOTAL=`grep '^Mem:' /tmp/free_$$.txt |awk '{print $2}'`

# Used Mem
MEM_USED=`grep '^-/+ buffers/cache:' /tmp/free_$$.txt |awk '{print $3}'`

# Used Mem %
MEM_USED_100=`echo "100 * ${MEM_USED}" |bc`
MEM_PCT=`echo "scale=3; ${MEM_USED_100}/${MEM_TOTAL}" |bc -l`
