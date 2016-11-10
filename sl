#!/bin/bash

while read l
do
  printf '%*s%s' $(tput cols) "$l"
done <<< "$(ls | rev)"
