#!/bin/bash

## Comentário

date > timer.txt

for i in $(seq 1 10)
 do
  echo 'Hello, world!'
done
date >> timer.txt
