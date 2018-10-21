#!/bin/bash

# Script para fazer benchmark com siesta

cd siesta-4.0.1
sh gfortran-compiler.sh
sh intel-compiler.sh

cd ../benzene
sh run.sh
cd time
sh analysis.sh
cd ../../
