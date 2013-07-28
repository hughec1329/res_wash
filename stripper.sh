#!/bin/bash
cat $1 | awk '/Date/ {print $2}' >> out
cat $1 | sed -n 7,30p | awk '{print $3}' >> out
echo '' >> out
cat $1 | sed -n 35,38p | awk '{gsub(/%/,"",$3) ;print $3}'>> out
