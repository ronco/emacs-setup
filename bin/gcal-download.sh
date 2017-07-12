#!/bin/bash

# customize these
WGET=/opt/boxen/homebrew/bin/wget
ICS2ORG=/Users/ronco/github/ical2org.py/ical2org.py
ICSFILE=/tmp/cal.ics
ORGFILE="/Users/ronco/Box Sync/ron-notes/org/calendar.org"
URL=$1
# no customization needed below

$WGET -O $ICSFILE $URL
/opt/boxen/homebrew/bin/python $ICS2ORG $ICSFILE > "$ORGFILE"
