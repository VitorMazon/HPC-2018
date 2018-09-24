#!/bin/bash
#rmdir Exercicio1
mkdir Exercicio1
cd Exercicio1
dir=20
pr=10

for i in $(seq 1 $dir)
 do
  mkdir exe-$i
  cd exe-$i
  for j in $(seq 1 $pr)
   do
    touch problema-$j
  done 
 cd ../
done

cd ../
