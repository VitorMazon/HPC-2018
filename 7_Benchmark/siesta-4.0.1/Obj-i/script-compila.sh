#!/sbin/bash

# ==============================================================================
#  Script para modificar o arch.make e compilar o programa com diferentes flags
# ==============================================================================


for i in 0 1 2 3
do
sed "s/ XYX/ -O$i/g" arch.intel > arch.make
make 
cp siesta siesta-intel-$i.x
cp arch.make arch-intel-$i
make clean
done
