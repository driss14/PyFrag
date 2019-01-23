#!/bin/sh

source $PYFRAGHOME/.pyfragrc

JOBDIR="$( cd "$(dirname "$1")" ; pwd -P )"
JOBNAME=`basename "$1"`
JOBPATH=$JOBDIR/$JOBNAME
VIDEODIR=$PYFRAGVIDEO/"${JOBNAME%.*}"
JOBSTATE=$JOBDIR/result/jobstate.txt
REMOTEDIR=$REMOTEBASE/"${JOBNAME%.*}"


fab -f $PYFRAGHOME/utils/resub/fabfile.py deploy:$JOBDIR,$REMOTEDIR,$JOBNAME &
