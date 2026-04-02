#!/bin/bash
COUNT=$(dunstctl count waiting)
PAUSED=$(dunstctl is-paused)

if [ "$PAUSED" == "true" ]; then
    CLASS="paused"
    TEXT=""
else
    CLASS="active"
    if [ "$COUNT" != "0" ]; then
        TEXT=" $COUNT"
    else
        TEXT=""
    fi
fi

printf '{"text": "%s", "class": "%s", "alt": "%s"}\n' "$TEXT" "$CLASS" "$CLASS"
