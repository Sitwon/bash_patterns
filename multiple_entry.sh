#!/bin/bash

# WARNING!
# THIS TECHNIQUE COULD EXPOSE A PRIVILEGE ESCALATION IF THE SCRIPT RUNS IN A
# PRIVILEGED CONTEXT, BUT CAN BE INVOKED FROM AN UNPRIVILEGED CONTEXT. FOR 
# EXAMPLE, USING SUDO OR A SETUID BIT.

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

# Handle mistyped commands in Bash >= 4.0
command_not_found_handle() {
	echo "The following command is not valid: \"${1}\""
	exit 1
}

if [ "${BASH_SOURCE}" = "${0}" ]; then
	if [ -n "${1}" ]; then
		CALL_FUNC="${1}"

		# Handle mistyped commands in Bash < 4.0
		if [ "$(type -t "${CALL_FUNC}")" != "function" ]; then
			echo "${CALL_FUNC}: Function not found." >&2
			exit 1
		fi

		shift
		"${CALL_FUNC}" "${@}"
	fi
fi
