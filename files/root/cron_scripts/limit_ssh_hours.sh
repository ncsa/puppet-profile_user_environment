#!/bin/bash

# KILL sshd PROCESSES OLDER THAN SPECIFIED HOURS

help()
{
    echo "Usage: $(basename $0) [ -t | --time ]
               [ -h | --help  ]"
    exit 2
}

SHORT=t:,h
LONG=time:,help
OPTS=$(getopt -a -n $0 --options $SHORT --longoptions $LONG -- "$@")

VALID_ARGUMENTS=$# # Returns the count of arguments that are in short or long options

if [ "$VALID_ARGUMENTS" -eq 0 ]; then
  help
fi

eval set -- "$OPTS"

while :
do
  case "$1" in
    -t | --time )
      elapsed_hours="$2"
      shift 2
      ;;
    -h | --help)
      help
      ;;
    --)
      shift;
      break
      ;;
    *)
      echo "Unexpected option: $1"
      help
      ;;
  esac
done

if [ "$elapsed_hours" ]
then
  elapsed_seconds=$(( elapsed_hours*60*60 ))
  #echo "elapsed_hours: ${elapsed_hours}"
  #echo "elapsed_seconds: ${elapsed_seconds}"

  ps -eo etimes,user,pid,args | grep sshd | grep -v root | sort -rn | while read line ; do
    sshd_elapsed_seconds=$(echo $line | awk '{ print $1 }')
    if (( sshd_elapsed_seconds >= elapsed_seconds )); then
      sshd_user=$(echo $line | awk '{ print $2 }')
      sshd_pid=$(echo $line | awk '{ print $3 }')
      sshd_terminal=$(echo $line | awk '{ print $NF }')
      #echo "seconds: ${sshd_elapsed_seconds} user: ${sshd_user} pid: ${sshd_pid}"
      echo "SSH sessions to $(hostname -f) are limited to ${elapsed_hours} hours.
User ${sshd_user} is being logged out from $(hostname -f) ${sshd_terminal} after ${elapsed_hours} hours..." | write $sshd_user
      sleep 30s && kill -9 $sshd_pid
      logger -t "$(basename $0)" "sshd session for user ${sshd_user} ${sshd_terminal} has been killed after ${elapsed_hours} hours"
    else
      #echo "All remaining ssh sessions are less than ${elapsed_hours} hours old."
      exit
    fi
  done
fi

