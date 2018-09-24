#!/bin/bash

for i in $(seq 1 10 1000000)
do
 ./flop $i >> mflops.dat
done
