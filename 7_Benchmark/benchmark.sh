#!/bin/bash

# Script para fazer benchmark com siesta

sh ./siesta-4.0.1/gfortran-compiler.sh
sh ./siesta-4.0.1/intel-compiler.sh

sh ./benzene/run.sh

sh ./benzene/time/analysis.sh
