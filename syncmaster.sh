#!/bin/bash

PARALLEL="1"

function transfer
{
    local src=$1
    local trg=$2
    local bnd=$3

    echo "STARTING - SOURCE: ${src} TARGET: ${trg} BANDWIDTH: ${bnd}"
    rsync --bwlimit=${BND} --progress --append --partial -vz -e 'ssh -p 22' ${src} ${trg}
    echo "COMPLETED - SOURCE: ${src} TARGET: ${trg} BANDWIDTH: ${bnd}"
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
    echo "Ambiguous number of parallel jobs given, reseting to 1"
    PARALLEL=1;
fi

# TRANSFERS must not be empty
if [ -z "${TRANSFERS}" ];
then
    echo "Exiting: TRANSFERS is empty";
    exit -1;
fi

# Verify that instance of script does not allready running
if pidof -o %PPID -x "$0">/dev/null;
then
    echo "Exiting: An instance of the script is allready running."
    exit -1;
fi


# Create and launch rsync jobs here
echo "$TRANSFERS" | tr -s " " "\n" | tr -s ";" " " | xargs -n 3 -P ${PARALLEL} bash -c 'transfer $1 $2 $3' bash
