#!/bin/bash

# =============================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags
# =============================================================================

#
# TROCAR OBJI PARA BASIS
#
mkdir Obj-intel
mkdir Obj-intel-flags
mkdir Obj-intel-mkl

# ifort sem flags
cd Obj-intel

sh ../Src/obj_setup.sh
cp ../Obji/arch.intel* ../Obji/script-compil* .
for i in 0 1 2 3
 do
  sed "s/ XYX/ -O$i/g" arch.intel1 > arch.make
  make
  cp siesta siesta-intel-$i.x
  make clean
  mv arch.make arch-intel-$i
done

cd ../
# ifort com flags
cd Obj-intel-flags
sh ../Src/obj_setup.sh
cp ../Obji/arch.intel* ../Obji/script-compil* .
for i in 0 1 2 3
 do
  sed "s/ XYX/ -O$i/g" arch.intel1 > arch.make
  make
  cp siesta siesta-intel-$i.x
  make clean
  mv arch.make arch-intel-$i
done
