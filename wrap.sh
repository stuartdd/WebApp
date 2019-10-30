#!/bin/bash
#set -e
echo $0
echo ScriptPath : $0
echo $1
echo Running : $1
echo $2
echo Pending : $2
echo $3
echo Status : $3
echo Wrap - start:
touch $3.running
sh $1
mv $3.running $3.ended.$STATUS
mv $1 $2
echo Wrap - end:
