#!/bin/bash
#set -e

ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCHED_PATH=$ROOT_PATH/sched
QUEUE_PATH=$SCHED_PATH/queued
STATUS_PATH=$SCHED_PATH/status
RUNNING_PATH=$SCHED_PATH/running
PENDING_PATH=$SCHED_PATH/pending
STATUS=0
FILES=*.sh
COUNT=0;

#WebApp.exe
until [ $STATUS -eq 1 ]
do  
    sleep 1
    cd $QUEUE_PATH
    for f in $FILES
    do
        if [ "$f" != "*.sh" ] 
        then
            echo "Processing $f file..."
            if [ ! -f "$STATUS_PATH/$f.running" ]; then
                rm -f $STATUS_PATH/$f.*
                mv $f $RUNNING_PATH/$f
                $ROOT_PATH/wrap.sh $RUNNING_PATH/$f $PENDING_PATH/$f $STATUS_PATH/$f
            fi
        fi
    done
    echo "Ping $COUNT"
    let COUNT++
done
