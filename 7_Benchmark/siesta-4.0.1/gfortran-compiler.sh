#!/bin/bash


#FAZER VERIFICAR A PASTA BIN!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


# =====================================================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags com compilador gfortran
# =====================================================================================================

DIRECTORY='~/bin'

# verifica se pasta /bin existe na home e a cria se não existir
# /bin usado para deixar os compilados do siesta

if [ ! -d "$DIRECTORY" ]; then
  mkdir ~/bin
fi

mkdir Obj-g
cd Obj-g
 sh ../Src/obj_setup.sh
 cp ../Basis/arch.gf .
 for i in 0 1 2 3
  do
   sed "s/ XYX/ -O$i/g" arch.gf > arch.make
   make
   cp siesta siesta-gf-$i.x
   mv siesta-gf-$i.x ~/bin
   make clean
   mv arch.make arch-gf-$i
 done
cd ..

mkdir Obj-g-flags
cd Obj-g-flags
 sh ../Src/obj_setup.sh
 cp ../Basis/arch.gf-flags .
 for i in 0 1 2 3
  do
   sed "s/ XYX/ -O$i/g" arch.gf-flags > arch.make
   make
   cp siesta siesta-gflags-$i.x
   mv siesta-gflags-$i.x ~/bin
   make clean
   mv arch.make arch-gflags-$i
 done
cd ..


