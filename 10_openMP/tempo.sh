#!/bin/bash

# =======================================================================
#   Script para rodar siesta e criar um aquivo com o  tempo de execucao
# =======================================================================
for j in $(seq 1 100)
do
  for i in 0 1 2 3
   do
    gcc soma$i.c 
    ./a.out > saida.out
    tempo=$(grep 'tempo = ' saida.out | cut -d = -f 2)
    echo $j '  ' $tempo >> t$i.dat
    rm *.out
  done
done
