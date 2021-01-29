#!/bin/bash

# RUN: sudo ./backup.sh $USER $DRIVE $SYSTEM

USER="$1"
DRIVE="$2"
SYSTEM="$3"
DATAPATH="/media/${USER}/${DRIVE}/${SYSTEM}"
LOGFILE="${DATAPATH}/backup.log"

if [ $# -lt 1 ]; then
    echo "No destination defined. Usage: $0 destination" >&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Too many arguments. Usage: $0 destination" >&2
    exit 1
elif [ ! -d "$DATAPATH" ]; then
   echo "Invalid path: $DATAPATH" >&2
   exit 1
elif [ ! -w "$DATAPATH" ]; then
   echo "Directory not writable: $DATAPATH" >&2
   exit 1
fi

START=$(date +%s)
echo -e "=================================================\n" >> $LOGFILE
echo "Backup initiated on $(date '+%Y-%m-%d, %T, %A')" >> $LOGFILE

rsync -aAX --progress --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/gloftus/.cache/*","/home/gloftus/dld/*","/home/gloftus/tmp/*","/home/gloftus/pgm/vms/*"} /* "$DATAPATH" 2>> $LOGFILE

FINISH=$(date +%s)
INTERVAL="$(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"
echo -e "Total time: $INTERVAL\n" >> $LOGFILE

