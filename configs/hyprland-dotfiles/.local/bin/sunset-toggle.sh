#!/bin/bash
if pgrep -x "hyprsunset" > /dev/null; then
    killall hyprsunset
else
    hyprsunset --temperature 3000 &
fi
