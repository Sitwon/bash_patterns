#!/bin/bash

parse_csv() {
	line="${1}"
	length="${#line}"
	position=0

	if [ $length = 0 ]; then
		return
	fi

	token=""
	quoted=0
	while [ $position -lt $length ]; do
		current="${line:$position:1}"
		case "${current}" in
			\")
				if [ $quoted = 0 ]; then
					quoted=1
				else
					quoted=0
				fi
				prev_pos=$(( position - 1 ))
				prev="${line:$prev_pos:1}"
				if [ "$prev" = \" ]; then
					token="${token}${current}"
				fi
				;;
			,)
				if [ $quoted = 0 ]; then
					break
				else
					token="${token}${current}"
				fi
				;;
			*)
				token="${token}${current}"
				;;
		esac
		(( ++position ))
	done
	(( ++position ))

	echo "${token}"
	parse_csv "${line:$position}"
}

if [ "$0" = "$BASH_SOURCE" ]; then
	while read -r line ; do
		array=( $(parse_csv "${line}") )
		declare -p array
	done
fi
