#!/bin/bash

before=$(date +%s%N)
sleep 2
after=$(date +%s%N)
elapsed=$(($after-$before))
echo "Elapsed: $elapsed nanoseconds, $(($elapsed/1000)) microseconds, $(($elapsed/1000000)) milliseconds"
