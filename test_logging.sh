#!/bin/bash

source logging.sh

info_log "argument"
info_log <<<"stdin"
echo "pipe" | info_log
echo "redirection" &> >(info_log)
info_log <<EOF
multi

line
EOF

echo
error_log "error"
warn_log "warning"
info_log "info"
debug_log "debug"
trace_log "trace"
echo

LOG_LEVEL=${TRACE}
value_of LOG_LEVEL
info_log "$(value_of LOG_LEVEL)"
value_of LOG_LEVEL | info_log
echo

error_log "error"
warn_log "warning"
info_log "info"
debug_log "debug"
trace_log "trace"
echo
add_log_target test.log
error_log "error"
warn_log "warning"
info_log "info"
debug_log "debug"
trace_log "trace"
echo
add_log_target SYSLOG
error_log "error"
warn_log "warning"
info_log "info"
debug_log "debug"
trace_log "trace"

function func2() {
	debug_log "foo"
	debug_log <<<"bar"
	print_stack_trace | info_log
}

function func1() {
	debug_log "foo"
	debug_log <<<"bar"
	func2
}

func1
