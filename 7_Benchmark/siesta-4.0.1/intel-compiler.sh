#!/bin/bash
# ===================================================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags para compilador ifort
# ===================================================================================================

DIRECTORY='~/bin'

# verifica se pasta /bin existe na home e a cria se não existir
# /bin usado para deixar os compilados do siesta
if [ ! -d "$DIRECTORY" ]; then
  mkdir ~/bin
fi

#------------------------------------
#---------Intel sem flags------------
#------------------------------------

mkdir Obj-i
cd Obj-i
 sh ../Src/obj_setup.sh
 cp ../Basis/arch.intel .
 
 for i in 0 1 2 3
  do
   sed "s/ XYX/ -O$i/g" arch.intel > arch.make
   make
   cp siesta siesta-intel-$i.x
   mv siesta-intel-$i.x ~/bin
   make clean
   mv arch.make arch-intel-$i
 done
 
cd ..

#------------------------------------
#--------Intel com flags-------------
#------------------------------------

mkdir Obj-i-flags
cd Obj-i-flags
 sh ../Src/obj_setup.sh
 cp ../Basis/arch.intel-flags .
 
 for i in 0 1 2 3
  do
   sed "s/ XYX/ -O$i/g" arch.intel-flags > arch.make
   make
   cp siesta siesta-intel-flags-$i.x
   mv siesta-intel-flags-$i.x ~/bin
   make clean
   mv arch.make arch-intel-flags-$i
 done
 
cd ..

#------------------------------------
#-------Intel com flags e mkl--------
#------------------------------------

mkdir Obj-i-mkl
cd Obj-i-mkl
 sh ../Src/obj_setup.sh
 cp ../Basis/arch.intel-mkl .
 
 for i in 0 1 2 3
  do
   sed "s/ XYX/ -O$i/g" arch.intel-mkl > arch.make
   make
   cp siesta siesta-intel-mkl-$i.x
   mv siesta-intel-mkl-$i.x ~/bin
   make clean
   mv arch.make arch-intel-mkl-$i
 done
 
cd ..
