#!/usr/bin/env bash
mass=-3.81

for L in 64 48 12 8; do
for i in {1..4}; do
    id=${RANDOM}
    TMPFILE=`mktemp --tmpdir=/home/jkott/perm/tmp`
    cp run_cpu.sh $TMPFILE

    echo "julia -t 16 thermalize.jl --cpu --fp64 --mass=$mass --rng=$id $L" >> $TMPFILE
    echo "rm $TMPFILE" >> $TMPFILE

    echo $TMPFILE

    chmod +x $TMPFILE
    bsub < $TMPFILE
done
done
