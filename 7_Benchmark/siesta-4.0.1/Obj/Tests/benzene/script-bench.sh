#!/sbin/bash

for i in 0 1 2 3
 do
  echo '	'
  echo 'Estou rodando o Bench', $i
  date >> tempo.txt
  siesta-$i < benzene.fdf > saida-$i.txt
  date >> tempo.txt
  rm *.CG *.XV *.DM
done
