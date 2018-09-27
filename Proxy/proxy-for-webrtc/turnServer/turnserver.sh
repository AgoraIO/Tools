#nohup ./turnserver 101.69.223.6:3478 101.69.223.6:3433 101.69.223.6 liaojun turnserver.conf & 
#!/bin/bash  
  
echo "***************************"  
program="turnserver"
echo "need external IPaddress"  
extIP="101.69.223.6"
echo "need UDP port and TCP port"  
udpport="3478"
tcpport="3433"
echo "need realm, example: agora.io"
realm="liaojun"
echo "***************************"  
  
#echo "PID of this script: $$"  
#echo "PPID of this script: $PPID"  
  
function Process()  
{  
    PIDCOUNT=`ps -ef | grep $program | grep -v "grep" | awk '{print $2}' | wc -l`;  
    case ${1} in
	start)
	    if [ ${PIDCOUNT} -le 0 ] ; then
	        echo "nohup ./$program $extIP:$udpport $extIP:$tcpport $extIP $realm turnserver.conf &";
	        sudo nohup ./$program $extIP:$udpport $extIP:$tcpport $extIP $realm turnserver.conf &
	    else
		echo "$program is running.";
	    fi
	    ;;
	stop)
    	    if [ ${PIDCOUNT} -gt 1 ] ; then  
        	echo "There are too many process contains $program";  
    	    elif [ ${PIDCOUNT} -le 0 ] ; then  
        	echo "No such process $program";  
		exit 1
    	    fi  
            PID=`ps -ef | grep $program | grep -v "grep" | grep -v ".sh" | awk '{print $2}'` ;  
            echo "Find the PID of this progress!--- process:$1 PID=[${PID}] ";  
    	    read -p "Are you sure you want to close this progress[y/n]: "  
    	    if [ $REPLY = "y" ] || [ $REPLY = "yes" ] ; then  
        	echo "Kill the process $program ...";  
        	kill -9  ${PID};  
        	echo "kill -9 ${PID} done!";  
    	    else  
        	echo "Confirmation of canceling,exit!";  
        	exit 1  
    	    fi  
    	    #if we use return ,the return val must between 0 and 255  
	    ;;
	*)
	    echo "usage: ./turnserver.sh [start/stop]";
	    ;;
	esac
}  
  
  
if [ $# -lt 1 ] ; then  
    echo "usage: ./turnserver.sh [start/stop]";
else  
    Process $1;  
fi
