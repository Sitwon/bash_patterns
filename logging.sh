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

LOG_LEVEL="${LOG_LEVEL:-0}"
DEBUG_LEVEL="${DEBUG_LEVEL:-3}"

trace(){ [ ${DEBUG_LEVEL} -ge 4 ] || return 1; }
debug(){ [ ${DEBUG_LEVEL} -ge 3 ] || return 1; }
info(){ [ ${DEBUG_LEVEL} -ge 2 ] || return 1; }
warn(){ [ ${DEBUG_LEVEL} -ge 1 ] || return 1; }
error(){ [ ${DEBUG_LEVEL} -ge 0 ] || return 1; }

trace_do(){ trace && eval "${@}" >&2 || return 0; }
debug_do(){ debug && eval "${@}" >&2 || return 0; }
info_do(){ info && eval "${@}" >&2 || return 0; }
warn_do(){ warn && eval "${@}" >&2 || return 0; }
error_do(){ error && eval "${@}" >&2 || return 0; }

trace_log(){ trace_do echo -e "\${BOLD_WHITE}[TRACE]\${BOLD_BLACK} \"${*}\"\${RESET_COLOR}"; }
debug_log(){ debug_do echo -e "\${BOLD_WHITE}[DEBUG]\${BOLD_BLUE} \"${*}\"\${RESET_COLOR}"; }
info_log(){ info_do echo -e "\${BOLD_WHITE}[INFO ]\${RESET_COLOR} \"${*}\"\${RESET_COLOR}"; }
warn_log(){ warn_do echo -e "\${BOLD_WHITE}[WARN ]\${BOLD_YELLOW} \"${*}\"\${RESET_COLOR}"; }
error_log(){ error_do echo -e "\${BOLD_WHITE}[ERROR]\${BOLD_WHITE_RED} \"${*}\"\${RESET_COLOR}"; }

log(){
	case "${1}" in
		4)
			shift
			trace_log "${*}"
			;;
		3)
			shift
			debug_log "${*}"
			;;
		2)
			shift
			info_log "${*}"
			;;
		1)
			shift
			warn_log "${*}"
			;;
		0)
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

