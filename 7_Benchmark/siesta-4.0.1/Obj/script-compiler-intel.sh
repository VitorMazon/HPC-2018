#!/bin/bash

# =============================================================================
#  Script para modificar arch.make e complilar o programa com diferentes flags
# =============================================================================

for i in 0 1 2 3
 do
  sed "s/ XYX/ -O$i/g" arch.intel-flags > arch.make
  make
  cp siesta siesta-intel-flags-$i.x
  make clean
  mv arch.make arch-intel-flags-$i
done
