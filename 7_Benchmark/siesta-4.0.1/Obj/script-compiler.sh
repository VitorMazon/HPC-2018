#!/bin/bash

# =============================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags
# =============================================================================

for i in 0 1 2 3
 do
  sed "s/ XYX/ -O$i/g" arch.gf > arch.make
  make
  cp siesta siesta-flags-$i.x
  make clean
  mv arch.make arch-flags-$i
done
