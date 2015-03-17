#!/bin/bash

exec 1> >( tee >(logger -s -t $(basename $0))) 2>&1

echo "Hello world"

