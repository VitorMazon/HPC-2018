#!/bin/bash

sed "196670,/END_BLOCK_DATAGRID_3D/d" gas.XSF > test.XSF
sed "1,61d" test.XSF > test.XSF

