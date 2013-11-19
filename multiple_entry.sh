#!/bin/bash

# This file demonstrates a script with multiple entry points.
# Try the following invocations:
#   $ ./multiple_entry.sh funcOne
#   $ ./multiple_entry.sh funcTwo 1 2 "3 4" 5

funcOne() {
	echo "Running funcOne"
}

funcTwo() {
	echo "Running funcTwo"
	local count=1
	for arg in "${@}"; do
		echo "[${count}]: ${arg}"
		(( count += 1 ))
	done
}

if [ "${BASH_SOURCE}" = "${0}" ]; then
	if [ -n "${1}" ]; then
		CALL_FUNC="${1}"
		shift
		"${CALL_FUNC}" "${@}"
	fi
fi
