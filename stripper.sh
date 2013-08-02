#!/bin/bash
cat $1 | awk '/Sent:/ {print $3,$4,$5}' >> out	# cant auto increment from here or get 0 - do in R
cat $1 | sed -n 6,29p | awk '{print $3}' >> out
echo '' >> out
cat $1 | sed -n 34,37p | awk '{gsub(/%/,"",$3) ;print $3}'>> out
