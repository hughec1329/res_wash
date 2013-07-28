#!/bin/bash

# script to do all steps of data extraction from text dump of 

# input = single text dump of all 'daily sales' emails
# output = 'out' single text file, each 30 lines new day

rm xx*
rm out
clear
echo 'splitting emails'
csplit -s $1 '/From:/' '{*}'
echo 'stripping wash data'
for file in xx*
do
	./stripper.sh $file
done
rm xx*
washes=$(wc -l out | awk '{print $1}')
wash=$((washes / 30))
echo $wash 'days data extracted'
