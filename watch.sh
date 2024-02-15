#!/usr/bin/env bash

n16=`ls measurements/magnetization_L_16_*_id_17663.dat | wc -l`
n24=`ls measurements/magnetization_L_24_*.dat | wc -l`

echo "16 progress: $n16"
echo "24 progress: $n24"
