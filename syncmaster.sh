#!/bin/bash

PARALLEL="1"

function transfer
{
    local src=$1
    local trg=$2
    local bnd=$3
    echo "`date +"%Y-%m-%dT%H:%M:%S"` - STAR - SOURCE: ${src} TARGET: ${trg} BAND: ${bnd}"
    rsync --ignore-existing --bwlimit=${BND} --progress --append --partial -vz -e 'ssh -p 22' ${src} ${trg} >/dev/null
    RSYNC_STATUS=$?
    if [ $RSYNC_STATUS -eq 0 ]; then
        echo "`date +"%Y-%m-%dT%H:%M:%S"` - COMPLETED - SOURCE: ${src} TARGET: ${trg} BAND: ${bnd}"
    else
        echo "`date +"%Y-%m-%dT%H:%M:%S"` - FAILED - SOURCE: ${src} TARGET: ${trg} BAND: ${bnd}"
    fi
}

export -f transfer

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -t|--transfers)
      TRANSFERS="$2"
      shift
      shift
      ;;
    -p|--parallel)
      PARALLEL="$2"
      shift
      shift
      ;;
  esac
done

# If parallel jobs less or equal to 0 then change value to 1
if [ "$PARALLEL" -le "0" ];
then
    echo "`date +"%Y-%m-%dT%H:%M:%S"` - Ambiguous number of parallel jobs given, reseting to 1"
    PARALLEL=1;
fi

# TRANSFERS must not be empty
if [ -z "${TRANSFERS}" ];
then
    echo "`date +"%Y-%m-%dT%H:%M:%S"` - Exiting: TRANSFERS is empty";
    exit -1;
fi

# Verify that instance of script does not allready running
if pidof -o %PPID -x "$0">/dev/null;
then
    echo "`date +"%Y-%m-%dT%H:%M:%S"` - Exiting: An instance of the script is allready running."
    exit -1;
fi


# Create and launch rsync jobs here
echo "$TRANSFERS" | tr -s " " "\n" | tr -s ";" " " | xargs -n 3 -P ${PARALLEL} bash -c 'transfer $1 $2 $3;true' bash
