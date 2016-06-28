#!/bin/bash
[ "$DEBUG" = "1" ] && set -o xtrace

# simple test method
assert() {
	local args=
	for arg in "$@"; do
		if [[ "$arg" =~ " " ]] ; then
			args=$args" '$arg'"
		else
			args=$args" $arg"
		fi
	done
	test=$(( $test + 1 ))
	if eval "$args" ; then
		echo TEST$(printf %02d $test)":OK [${FUNCNAME[1]}] $args  at line" ${BASH_LINENO[0]} >&2
		ok=$(( $ok + 1 ))
	else
		echo TEST$(printf %02d $test)":NG [${FUNCNAME[1]}] $args  at line" ${BASH_LINENO[0]} >&2
	fi
}
echo_result() {
	echo result: $ok/$test succeeded
}


### main
CLGREP=./clgrep.pl
TESTFILE=test/clmemo_sample.txt
TMPFILE=tmp

# move to parent dir
TESTDIR=$(cd $(dirname $0); pwd)
cd $TESTDIR/..


test_all_print() {
	$CLGREP . $TESTFILE > $TMPFILE
	assert [ -z "$(diff -u -B $TESTFILE $TMPFILE)" ]
}

# TBD...

case "$1" in
	*)
		if [ -n "$1" ]; then
			echo "only test: $1"
			eval $1
		else
			#declare -f
			for test_func in $(declare -f | awk '/^test_/ {print $1}'); do
				$test_func
			done
		fi
esac

echo_result
rm -f $TMPFILE
