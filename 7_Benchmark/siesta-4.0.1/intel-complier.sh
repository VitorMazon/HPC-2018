#!/bin/bash
#APRIMORAR: JOGAR O COMPILADO PARA A PASTA /bin PARA QUANDO FOR RODAR
# =========================================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags para ifort
# =========================================================================================

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
   make clean
   mv arch.make arch-intel-mkl-$i
 done
 
cd ..

