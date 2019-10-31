#!/bin/bash
#set -e

ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCHED_PATH=$ROOT_PATH/sched
PENDING_PATH=$SCHED_PATH/pending
if [ ! -d $PENDING_PATH ]; then
    mkdir $PENDING_PATH
fi
QUEUE_PATH=$SCHED_PATH/.queued
if [ ! -d $QUEUE_PATH ]; then
    mkdir $QUEUE_PATH
fi
STATUS_PATH=$SCHED_PATH/.status
if [ ! -d $STATUS_PATH ]; then
    mkdir $STATUS_PATH
fi
RUNNING_PATH=$SCHED_PATH/.running
if [ ! -d $RUNNING_PATH ]; then
    mkdir $RUNNING_PATH
fi
LOG_PATH=$SCHED_PATH/.logs
if [ ! -d $LOG_PATH ]; then
    mkdir $LOG_PATH
fi
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
                LOGFILE=`date +%Y_%m_%d_%H_%M_%S`.log
                rm -f $STATUS_PATH/$f.*
                mv $f $RUNNING_PATH/$f
                nohup $ROOT_PATH/wrap.sh $RUNNING_PATH/$f $PENDING_PATH/$f $STATUS_PATH/$f $LOG_PATH/$f-$LOGFILE </dev/null >/dev/null 2>&1 &
            fi
        fi
    done
    echo "Ping $COUNT"
    let COUNT++
done
