#!/bin/bash
#set -e
ROOT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"

FILES=*.sh
SP_FILE=.scheduler.json

#
# Check ALL of the directories exist. Create if not.
#
# Pending - this is where the jobs are stored
#
SCHED_PATH=$ROOT_PATH/sched
PENDING_PATH=$SCHED_PATH/pending
if [ ! -d $PENDING_PATH ]; then
    mkdir $PENDING_PATH
fi
#
# Queue - this is where to copy the jobs when you want them run
#
QUEUE_PATH=$SCHED_PATH/.queued
if [ ! -d $QUEUE_PATH ]; then
    mkdir $QUEUE_PATH
fi
#
# Status - A single file per job showing the status.
#   <jobfilename>.running
#   <jobfilename>.ended.<status>
#   If <jobfilename>.running exists then no action is taken
#
STATUS_PATH=$SCHED_PATH/.status
if [ ! -d $STATUS_PATH ]; then
    mkdir $STATUS_PATH
fi
#
# Running - Job is copied here then run
#     Unless $STATUS_PATH/<jobfilename>.running exists
#
RUNNING_PATH=$SCHED_PATH/.running
if [ ! -d $RUNNING_PATH ]; then
    mkdir $RUNNING_PATH
fi
#
# This is where the job should log it's activities.
# The full log name is passed to the job when run.
#     $LOG_PATH/<jobfilename>-<datatime>.log
#
LOG_PATH=$SCHED_PATH/.logs
if [ ! -d $LOG_PATH ]; then
    mkdir $LOG_PATH
fi
#
# Create a properties file with all the config data in it
#
# Remove the old properties file so we can always start fresh
#
SCHED_PROPERTIES=$ROOT_PATH/$SP_FILE
if [ -f $SCHED_PROPERTIES ]; then
    rm $SCHED_PROPERTIES
fi
#
# Add properties
#
echo "{" >> $SCHED_PROPERTIES
echo "\"scheduler\":" >> $SCHED_PROPERTIES
echo "  {" >> $SCHED_PROPERTIES
echo "    \"created\":\"`date +%Y-%m-%dT%H:%M:%S`\"," >> $SCHED_PROPERTIES
echo "    \"scheduler\":\""$SCHED_PATH"\"," >> $SCHED_PROPERTIES
echo "    \"pending\":\""$PENDING_PATH"\"," >> $SCHED_PROPERTIES
echo "    \"queue\":\""$QUEUE_PATH"\"," >> $SCHED_PROPERTIES
echo "    \"status\":\""$STATUS_PATH"\"," >> $SCHED_PROPERTIES
echo "    \"logs\":\""$LOG_PATH"\"," >> $SCHED_PROPERTIES
echo "    \"running\":\""$RUNNING_PATH"\"" >> $SCHED_PROPERTIES
echo "  }," >> $SCHED_PROPERTIES
echo "\"tasks\":{" >> $SCHED_PROPERTIES
FILES=*.sh
cd $PENDING_PATH 
ID=0
for f in $FILES; do
    echo "    \"task_"$ID"\":\""$f"\"," >> $SCHED_PROPERTIES
    let ID++
done
echo "    \"_D_"$ID"\":\"dummy"\" >> $SCHED_PROPERTIES
echo "  }" >> $SCHED_PROPERTIES
echo "}" >> $SCHED_PROPERTIES


# echo "" >> $SCHED_PROPERTIES
#
# 
#
COUNT=0
STATUS=0

#WebApp.exe

while [ 1 ]
do  
    sleep 3
    cd $QUEUE_PATH
    for f in $FILES; do
        if [ "$f" != "*.sh" ] 
        then
            if [ ! -f "$STATUS_PATH/$f.running" ]; then
                LOGFILE=`date +%Y_%m_%d_%H_%M_%S`.log
                echo "Processing $f log = $f-$LOGFILE"
                rm -f $STATUS_PATH/$f.*
                mv $f $RUNNING_PATH/$f
                nohup $ROOT_PATH/wrap.sh $RUNNING_PATH/$f $PENDING_PATH/$f $STATUS_PATH/$f $LOG_PATH/$f-$LOGFILE </dev/null >/dev/null 2>&1 &
            fi
        fi
    done
    echo "Ping $COUNT"
    let COUNT++
done
