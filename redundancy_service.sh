#! /bin/bash
#
# Description: Shell script to ping main server periodically, if there's no reply
#              then this script will run all services that needed to takeover the service
# (fuad.hasan@bigjava.com)

if [[ $1 = '-b' && -n $2 && -n $3  && -n $4 ]]
    then
        while true; do
        ping -c 1 $2 | grep '100.0%' >> /dev/null
        if [ $? = 0 ]
            then
            echo '1' >> $4
        else
            echo '0' >> $4
        fi
        sleep $3
        done
elif [[ $1 = '-b' && -n $2 && -n $3 ]]
    then
        while true; do
        ping -c 1 $2 | grep '100.0%' >> /dev/null
        if [ $? = 0 ]
            then
            echo '1'
            #run service
        else
            echo '0'
        fi
        sleep $3
        done
elif [[ -n $1 && -n $2 && -n $3 ]]
    then
    while true; do
        date | tr -d "\n" >> $3
        echo ' - ' | tr -d "\n" >> $3
        ping -c 1 $1 | grep 'packets'  >> $3
        sleep $2
        done
elif [[ -n $1 && -n $2 ]]
    then
    while true; do
        date | tr -d "\n"
        echo ' - ' | tr -d "\n"
        ping -c 1 $1 | grep 'packets'
        sleep $2
        done
else
    echo 'usage: hb [-b] host interval [outputfile]

       -b   Outputs 0 if the ping was successful, 1 if it is not.
       ^C   Press Control-C to stop the script
       '
exit

fi