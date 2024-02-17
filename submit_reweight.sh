#!/usr/bin/env bash

id=${RANDOM}
TMPFILE=`mktemp --tmpdir=/home/jkott/perm/tmp`
cp run_cpu.sh $TMPFILE

echo "julia -t 16 reweighted_binder.jl" >> $TMPFILE
echo "rm $TMPFILE" >> $TMPFILE

echo $TMPFILE

chmod +x $TMPFILE
bsub < $TMPFILE
