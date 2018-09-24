#!/bin/bash

cd cutoff/

for i in $(seq 50 50 500)
do
 Ene=$(grep "Total =" tube-$i.out | cut -d = -f2)
 echo $i'	'$Ene >> ecutoff.dat
done

cd ../kpoint/

for i in $(seq 4 24)
do
 Ene=$(grep "Total =" tube-$i.out | cut -d = -f2)
 echo $i'       '$Ene >> ekpoint.dat
done
cd ../

#graficos
mv cutoff/ecutoff.dat .
mv kpoint/ekpoint.dat .
gnuplot graf.gp

mv cut.png cutoff/
mv kp.png kpoint/
