#!/bin/bash

declare -i LOOPS=(60*5)

# CPU
sar -u 1 $LOOPS | tail -n 1 | awk '{print 100 - $8}' > CPU_AVG.txt &

# Mem
sar -r 1 $LOOPS | tail -n 1 | awk '{print $5}' > MEM_AVG.txt &

# Disk
sar -d 1 $LOOPS | tail -n 1 | awk '{print $10}' > DSK_AVG.txt &

# Network
sar -n DEV 1 $LOOPS | grep 'Average' | grep 'eth0' | awk '{print $5 " " $6}'  >  NETWORK.txt &

declare -i COUNTER=0

while [[ $(jobs -r) ]]
do
  COUNTER=($COUNTER+1)
  sleep 1
done

# - - - - - - -

echo -n "%CPU: " > RESULT.txt
cat CPU_AVG.txt | awk '{print $1}' >> RESULT.txt

echo -n "%Mem: " >> RESULT.txt
cat MEM_AVG.txt | awk '{print $1}' >> RESULT.txt

echo -n "%DSK: " >> RESULT.txt
cat DSK_AVG.txt | awk '{print $1}' >> RESULT.txt

echo -n "NT Rx: " >> RESULT.txt
cat NETWORK.txt | awk '{print $1}' >> RESULT.txt

echo -n "NT Tx: " >> RESULT.txt
cat NETWORK.txt | awk '{print $2}' >> RESULT.txt

echo -e "\n" >> RESULT.txt
# - - - - - - -

cat RESULT.txt

wait
