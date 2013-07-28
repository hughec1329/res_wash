#!/bin/bash
cat $1 | awk '/Sent:/ {print $3-1,$4,$5}' >> out
cat $1 | sed -n 6,29p | awk '{print $3}' >> out
echo '' >> out
cat $1 | sed -n 34,37p | awk '{gsub(/%/,"",$3) ;print $3}'>> out
