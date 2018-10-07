#!/bin/bash

# =============================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags
# =============================================================================

mkdir Obj-g
cd Obj-g
 sh ../Src/obj_setup.sh
 cp ../Basis/arch.gf .
 for i in 0 1 2 3
  do
   sed "s/ XYX/ -O$i/g" arch.gf > arch.make
   make
   cp siesta siesta-gf-$i.x
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
   make clean
   mv arch.make arch-gflags-$i
 done
cd ..


