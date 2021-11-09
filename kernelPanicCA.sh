#!/bin/bash
#
# Custom command attribute check for kernel panics which occurred in the last seven days.
# Displays the number of occurences.
#
#

PanicLogCount=$(/usr/bin/find /Library/Logs/DiagnosticReports -Btime -7 -name *.panic | grep . -c)

/bin/echo "$PanicLogCount"
