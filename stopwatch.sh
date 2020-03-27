#!/bin/bash

if [ -t 0 ]; then
  SAVED_STTY="`stty --save`"
  stty -echo -icanon -icrnl time 0 min 0
fi

echo -e "Press ' ': stop, start\r\nPress 'r' when it is stop: reset\r\nPress 'q' when it is stop: quit"

count=0
keypress=''
dateWait=0
dateWaitSum=0

function stopwatch(){
    if [[ -z ${date1}  ]]; then
        date1=`date +%s`;
    fi 
   while [ "x$keypress" != "x " ]; do
    timerCalculated="$(date -u --date @$((`date +%s` - $date1 - $dateWaitSum)) +%H:%M:%S)\r"
    echo -ne "${timerCalculated}\t\t      \r"; 
    keypress="`cat -v`"
    sleep 0.1
   done
    keypress=''
    waiting
}

function waiting(){
    dateWait=`date +%s`
        while [ "w$keypress" != "w " ]; do
            echo -ne "stoped at $timerCalculated\r"
            keypress="`cat -v`"
            if [[ "$keypress" = "r"  ]]; then
                dateWaitSum=0
                keypress=''
                date1=`date +%s`;
                echo
                stopwatch
            elif [[ "$keypress" = "q"  ]]; then
                if [ -t 0 ]; then stty "$SAVED_STTY"; fi
                exit 0
            fi

        done
        dateWaitInterrupt=$((`date +%s` - $dateWait))
        dateWaitSum=$(($dateWaitSum + $dateWaitInterrupt))

    keypress=''
    echo
    stopwatch
}

stopwatch
