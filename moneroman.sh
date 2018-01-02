#!/bin/bash

#Copyright (c) 2017 Brandon Foltz

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#This version of the script is designed with xmr-stak 2.2.0 in mind.

#Set this to the command which should run in 'low performance' mode
LOW_MINER_COMMAND="/home/username/xmr-stak/bin/xmr-stak --config /home/username/xmr-stak/config.txt --cpu /home/username/xmr-stak/cpu-low.txt >> /home/username/xmr-stak/log.txt"

#Set this to the command which should run in 'high performance' mode
HIGH_MINER_COMMAND="/home/username/xmr-stak/bin/xmr-stak --config /home/username/xmr-stak/config.txt --cpu /home/username/xmr-stak/cpu-high.txt >> /home/username/xmr-stak/log.txt"

#Name of the process being managed
MINER_PROCESS_NAME="xmr-stak"

#Names of processes which when running will cause the managed process to switch to low performance mode
WHITELISTED_PROCESSES=("chrome" "firefox" "java")

#Don't change anything below this comment

CURRENT_MODE="LOW"
while true; do
	MINER_PID=$(ps -A | grep "$MINER_PROCESS_NAME" | awk '{print $1}')
	
	BRUNNING=0
	for i in ${WHITELISTED_PROCESSES[@]}; do
		WLPID=$(ps -A | grep "$i" | awk '{print $1}')
		#WLPID=$( (ps -A | grep "$i" | awk '{print $1}'; ) 2>&1 )		
		if [ "$WLPID" != "" ]; then
			BRUNNING=1
			echo "$i is running at $WLPID"
		fi
	done

	if [ "$MINER_PID" == "" ]; then
		echo "Miner not running."
		
		if [ $BRUNNING == 1 ]; then
			#start low mode
			echo "Starting $MINER_PROCESS_NAME in low performance mode..."
			eval $LOW_MINER_COMMAND
			CURRENT_MODE="LOW"
		else
			#start high mode
			echo "Starting $MINER_PROCESS_NAME in high performance mode..."
			eval $HIGH_MINER_COMMAND
			CURRENT_MODE="HIGH"
		fi
	
	else
		echo "Miner currently running in $CURRENT_MODE performance mode."
		if [ "$CURRENT_MODE" == "LOW" ]; then
			if [ $BRUNNING == 0 ]; then
				echo "Switching $MINER_PROCESS_NAME to high performance mode..."
				kill $MINER_PID
				pkill "cpulimit"
			fi
		elif [ "$CURRENT_MODE" == "HIGH" ]; then
			if [ $BRUNNING == 1 ]; then
				echo "Switching $MINER_PROCESS_NAME to low performance mode..."
				kill $MINER_PID
			fi
		fi
	fi

	sleep 5
done
