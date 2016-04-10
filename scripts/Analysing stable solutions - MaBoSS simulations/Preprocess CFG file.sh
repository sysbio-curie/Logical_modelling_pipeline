#!/usr/bin/bash

# Define outputs in file called "listOut" (needed for _ko and _up parameters of epistasis) and inputs in file called "listIn" (needed for is_internal parameters of MaBoSS), one output per line
grep istate ginsim_out.cfg > listA.temp
outputs=$(sed ':a;N;$!ba;s/\n/ -e /g;s/^/ -e /g' listOut)
inputs=$(sed ':a;N;$!ba;s/\n/ -e /g;s/^/ -e /g' listIn)
# echo "$outputs" >out
grep -v $outputs listA.temp > listB.temp
sed s'/.istate/_ko/' listB.temp > listB_ko.temp
sed s'/.istate/_up/' listB.temp > listB_up.temp
cat listB_ko.temp >> listB_up.temp 
cp ginsim_out.cfg ginsim_out2.cfg
sort listB_up.temp | sed 's/^/\$/;1i\\' >> ginsim_out2.cfg

grep -v $inputs listB.temp > listC.temp
sed s'/istate=0/is_internal = 1/' listC.temp >> ginsim_out2.cfg

rm *.temp
