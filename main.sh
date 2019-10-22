#!/bin/bash
#set -e

STATUS=0
SCHED_PATH=sched/start
FILES=*.sh

#WebApp.exe
cd $SCHED_PATH
until [ $STATUS -eq 1 ]
do  
    sleep 1
    for f in $FILES
    do
        if [ "$f" != "*.sh" ] 
        then
            echo "Processing $f file..."
            mv $f ../run
            cat ../run/$f
            status=$?
            echo $STATUS
        fi
    done
done
