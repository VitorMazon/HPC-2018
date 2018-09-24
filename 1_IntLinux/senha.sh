#!/bin/bash

VALID_PASS='hpc'

echo 'Entre com a senha:'
read senha

if [ "$VALID_PASS" == "$senha" ]
then
 echo 'Acesso permitido!'
else
 echo 'Acesso negado!'
fi
