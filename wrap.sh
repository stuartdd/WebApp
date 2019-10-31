#!/bin/bash
#set -e
touch $3.running
sh $1 > $4
STATUS=$?
mv $3.running $3.ended.$STATUS
mv $1 $2