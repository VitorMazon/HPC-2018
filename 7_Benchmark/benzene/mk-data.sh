#!/bin/bash

# =======================================================================
#   Script para rodar siesta e criar um aquivo com o  tempo de execucao
# =======================================================================

for i in 2 3
 do
  siesta-COMP-$i.x < benzene.fdf > saida.out
  rm *.DM *.XV *.CG
  tempo=$(grep 'Elapsed wall time (sec)' saida.out | cut -d = -f 2)
  echo $i '  ' $tempo >> COMP-tempo.dat
done

mv COMP-tempo.dat ./time
