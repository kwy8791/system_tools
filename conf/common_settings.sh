#!/bin/sh

####5####0####5####0####5####0####5####0
# unvariables
####5####0####5####0####5####0####5####0
export PATH="${PATH}:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:./bin"
export datetime_cmd="date +%Y-%m-%d_%H:%M:%S"

####5####0####5####0####5####0####5####0
# functions
####5####0####5####0####5####0####5####0
function f_eecho() {
	echo -e "`${datetime_cmd}`\t$@"
}

function f_necho() {
	echo -e -n "`${datetime_cmd}`\t$@"
}

