#!/bin/bash
#
# Custom command attribute check for kernel panics which occurred in the last forteen days.
# Displays the number of occurences.
#
#

PanicLogCount=$(/usr/bin/find /Library/Logs/DiagnosticReports -Btime -14 -name *.panic | grep . -c)

/bin/echo "$PanicLogCount"
