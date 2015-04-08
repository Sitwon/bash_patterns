#!/bin/bash

if [ -n "${LOGGING_DEFINED}" ]; then
	return
else
	export LOGGING_DEFINED="yes"
fi

. colors.sh

# Debug logging
TRACE=4
DEBUG=3
INFO=2
WARN=1
ERROR=0

LOG_LEVEL="${LOG_LEVEL:-${INFO}}"

_LOG_TARGETS=( STDERR )

trace(){ [ ${LOG_LEVEL} -ge ${TRACE} ]; }
debug(){ [ ${LOG_LEVEL} -ge ${DEBUG} ]; }
info(){ [ ${LOG_LEVEL} -ge ${INFO} ]; }
warn(){ [ ${LOG_LEVEL} -ge ${WARN} ]; }
error(){ [ ${LOG_LEVEL} -ge ${ERROR} ]; }

trace_do(){ trace && eval "${@}" >&3 || return 0; }
debug_do(){ debug && eval "${@}" >&3 || return 0; }
info_do(){ info && eval "${@}" >&3 || return 0; }
warn_do(){ warn && eval "${@}" >&3 || return 0; }
error_do(){ error && eval "${@}" >&3 || return 0; }

escape(){ [ -n "${*}" ] && printf '%q ' "${@}"; }

trace_log(){
	trace || return
	if [ $# -eq 0 ]; then
		while IFS= read _LINE; do
			echo -e "${BOLD_WHITE}[TRACE] ${BOLD_BLACK}${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}: ${_LINE}${RESET_COLOR}" >&3
		done
		return
	fi
	echo -e "${BOLD_WHITE}[TRACE] ${BOLD_BLACK}${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}: ${@}${RESET_COLOR}" >&3
}
debug_log(){
	debug || return
	if [ $# -eq 0 ]; then
		while IFS= read _LINE; do
			echo -e "${BOLD_WHITE}[DEBUG] ${BOLD_BLUE}${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}: ${_LINE}${RESET_COLOR}" >&3
		done
		return
	fi
	echo -e "${BOLD_WHITE}[DEBUG] ${BOLD_BLUE}${BASH_SOURCE[1]}:${FUNCNAME[1]}:${BASH_LINENO[0]}: ${@}${RESET_COLOR}" >&3
}
info_log(){
	info || return
	if [ $# -eq 0 ]; then
		while IFS= read _LINE; do
			echo -e "${BOLD_WHITE}[INFO ] ${RESET_COLOR}${_LINE}${RESET_COLOR}" >&3
		done
		return
	fi
	echo -e "${BOLD_WHITE}[INFO ] ${RESET_COLOR}${@}${RESET_COLOR}" >&3
}
warn_log(){
	warn || return
	if [ $# -eq 0 ]; then
		while IFS= read _LINE; do
			echo -e "${BOLD_WHITE}[WARN ] ${BOLD_YELLOW}${_LINE}${RESET_COLOR}" >&3
		done
		return
	fi
	echo -e "${BOLD_WHITE}[WARN ] ${BOLD_YELLOW}${@}${RESET_COLOR}" >&3
}
error_log(){
	error || return
	if [ $# -eq 0 ]; then
		while IFS= read _LINE; do
			echo -e "${BOLD_WHITE}[ERROR] ${BOLD_WHITE_RED}${_LINE}${RESET_COLOR}" >&3
		done
		return
	fi
	echo -e "${BOLD_WHITE}[ERROR] ${BOLD_WHITE_RED}${@}${RESET_COLOR}" >&3
}

log(){
	case "${1}" in
		${TRACE})
			shift
			trace_log "${*}"
			;;
		${DEBUG})
			shift
			debug_log "${*}"
			;;
		${INFO})
			shift
			info_log "${*}"
			;;
		${WARN})
			shift
			warn_log "${*}"
			;;
		${ERROR})
			shift
			error_log "${*}"
			;;
		*)
			error_log "Unknown log level \"${*}\""
			shift
			error_log "${*}"
			;;
	esac
}

value_of() {
	while [ $# -ge 1 ]; do
		echo "${1}=\"${!1}\""
		shift
	done
}

print_stack_trace() {
	local i=0
	local FRAMES=${#BASH_LINENO[@]}
	# FRAMES-2 skips main, the last one in arrays
	echo 'Stack Trace:'
	for ((i=FRAMES-2; i>=0; i--)); do
		echo '  File' \"${BASH_SOURCE[i+1]}\", line ${BASH_LINENO[i]}, in ${FUNCNAME[i+1]}
		# Grab the source code of the line
		sed -n "${BASH_LINENO[i]}{s/^/    /;p}" "${BASH_SOURCE[i+1]}"
		# It requires `shopt -s extdebug'
	done
	echo
}

enable_syslog() {
	add_log_target SYSLOG
}

init_log_targets() {
	FIRST=
	exec 3>&-
	for TARGET in ${_LOG_TARGETS[@]}; do
		case "${TARGET}" in
			"STDOUT")
				[ -z "${FIRST}" ] && exec 3>&1 || exec 3> >(tee >(cat) >&3)
				FIRST=done
				;;
			"STDERR")
				[ -z "${FIRST}" ] && exec 3>&2 || exec 3> >(tee >(cat >&2) >&3)
				FIRST=done
				;;
			"SYSLOG")
				[ -z "${FIRST}" ] && exec 3> >(logger -t "$(basename "${0}")") \
					|| exec 3> >(tee >(logger -t "$(basename "${0}")") >&3)
				FIRST=done
				;;
			*)
				[ -z "${FIRST}" ] && exec 3> "${TARGET}" \
					|| exec 3> >(tee -a "${TARGET}" >&3)
				FIRST=done
				;;
		esac
	done
}

add_log_target() {
	while [ $# -ge 1 ]; do
		_LOG_TARGETS[${#_LOG_TARGETS[*]}]="${1}"
		shift
	done
	init_log_targets
}

init_log_targets
