#!/bin/bash
set -E

trap 'catch $?' ERR

catch() {
    echo "Caught error $1 in:" >&2
    frame=0
    line="$(caller $frame 2>&1 | cut -d ' ' -f 1)"
    while [ -n "$line" ]; do
        subroutine="$(caller $frame 2>&1 | cut -d ' ' -f 2)"
        file="$(caller $frame 2>&1 | cut -d ' ' -f 3)"
        echo "From $file:$line:$subroutine" >&2
        echo "    $(sed -n ${line}p $file)" >&2
        ((frame++))
        line="$(caller $frame 2>&1 | cut -d ' ' -f 1)"
    done
    echo >&2
}

something_else() {
    echo "foobar"
    false
}

do_something() {
    false
    echo "something"
    something_else
}

echo "begin"
false
do_something
echo "end"
