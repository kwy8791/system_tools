#!/bin/sh

# df -m
df -m > /tmp/df_$$.txt

# Used percent
DISK_USED_PCT=`grep '/$' /tmp/df_$$.txt |awk '{print $5}' |sed -e "s/%//"`
