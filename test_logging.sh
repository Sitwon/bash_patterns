#!/bin/bash

source logging.sh

info_log "argument"
info_log <<<"stdin"
echo "pipe" | info_log
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

