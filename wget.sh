#!/bin/bash

wget() {
	local PROTO=${1%%://*}
	local NOPROTO=${1#*://}
	local HOST=${NOPROTO%%/*}
	local PORT=${HOST#*:}
	[ "${HOST}" = "${PORT}" ] && PORT=80
	HOST=${HOST%:*}
	local URI=${NOPROTO#*/}
	[ "${URI}" = "${NOPROTO}" ] && URI=
	URI="/${URI}"
	(
		exec 3<>/dev/tcp/${HOST}/${PORT}
		echo -e "GET ${URI} HTTP/1.1\r\nHost: ${HOST}\r\nConnection: close\r\n\r\n" >&3
		cat <&3
	)
}

if [ "${BASH_SOURCE}" = "${0}" ]; then
	wget "${@}"
fi
