#!/bin/bash

exec 1> >(tee >(logger -t $(basename $0)))
exec 2> >(tee >(logger -p err -t $(basename $0)) >&2)

echo "Hello world"
echo "Goodbye world" >&2

