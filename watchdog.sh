#!/bin/bash
#
# Description:
# Watch for vdpi-related daemons, if failure happened,
# then restart all daemons
#

# find daemon's pid
FIND_DEMA=`pgrep -n dema`
FIND_TCPDUMP=`pgrep tcpdump `
#FIND_VDAEMON=`pgrep sshd`
#FIND_TRACE=`pgrep trace`
#FIND_something=`pgrep something`

# command to restart daemon
COM_DEMA="/opt/script/vdpi/here"
COM_TCPDUMP="/usr/sbin/tcpdump -p -n -i any -C 1 -w /opt/vdpi/pol_1/sol_1/new/capture"
#COM_VDAEMON="/etc/init.d/sshd start"
#COM_TRACE="/etc/init.d/syslog start"
#COM_something="/etc/init.d/cups start"


# check dema
if [ -z "${FIND_DEMA}" ]; then
      echo "DEMA failed at `date`";
      $COM_DEMA;
else
      echo "DEMA it's still alive!"
fi

# check tcpdump
if [ -z "${FIND_TCPDUMP}" ]; then
      echo "TCPDUMP failed at `date`";
      $COM_TCPDUMP;
else
      echo "TCPDUMP it's still alive!"
fi

#check vdaemon
#if [ -z "${FIND_VDAEMON}" ]; then
#      echo "VDAEMON failed at `date`"
#      $COM_VDAEMON;
#else
#      echo "VDAEMON it's still alive!"
#fi

#check trace
#if [ -z "${FIND_TRACE}" ]; then
#      echo "TRACE failed at `date`";
#      $COM_TRACE;
#else
#      echo "TRACE it's still alive!"
#fi

#check something
#if [ -z "${FIND_something}" ]; then
#      echo "something failed at `date`";
#      $COM_something;
#else
#      echo "something it's still alive!"
#fi

exit 0

#
# add to crontab:
# crontab -e
# * * * * * /opt/bin/script/vdpi_daemon_watcher.sh 2>&1
#
# example using ps and grep
#if [ -f $PIDFILE ]
#then
#    ps aux | grep "^[^0-9]*$(cat $PIDFILE)" > /dev/null
#    if [ $? -ne 0 ]
#    then
#        $COMMAND
#    fi
#else
#    $COMMAND
#fi
