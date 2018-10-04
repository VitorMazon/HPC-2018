#!/bin/bash

sed "196670,/END_BLOCK_DATAGRID_3D/d" gas.XSF > aux.XSF
sed "1,61d" aux.XSF > col1.XSF
rm aux.XSF

sed "199998,/END_BLOCK_DATAGRID_3D/d" dev.XSF > gap.XSF
sed "196670,/199998/d" gap.XSF > aux.XSF		#Comando 'sed' para o arquivo todo não funciona, por isso divido em dois
sed "1,61d" aux.XSF > col2.XSF
rm aux.XSF
rm gap.XSF

#paste

paste < (awk '{printf "%12.6f \n", $1}' col1.XSF) < (awk '{printf "%12.6\n", $1}' col2.XSF) > fim.dat
