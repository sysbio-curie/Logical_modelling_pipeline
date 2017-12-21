#!/usr/bin/env bash

# - modifying CFG file
# Define outputs in file called "listOut" (needed for _ko and _up parameters of epistasis) and inputs in file called "listIn" (needed for is_internal parameters of MaBoSS), one output per line
sed -i.temp 's/ =/=/g;s/= /=/g;s/ ;/;/g' ginsimout.cfg

states=$(grep Node ginsimout.bnd | sed 's/Node //g;s/ {//g')
inputs=$(sed ':a;N;$!ba;s/\n/ /g;s/^/ /g' listIn.txt)
output=$(sed ':a;N;$!ba;s/\n/ -e /g;s/^/ -e /g' listOut.txt)
outputs=$(sed ':a;N;$!ba;s/\n/ /g;s/^/ /g' listOut.txt)

cp ginsimout.cfg ginsimout_original.cfg
statesnoout=$(grep -v "$output" <<<"$states")
state_ko=$(echo "$statesnoout" | sed 's/$/_ko=0;/g')
state_up=$(echo "$statesnoout" | sed 's/$/_up=0;/g')
states2=$(printf "%s\n" ${state_ko[@]} ${state_up[@]})
IFS=$'\n' sorted=($(sort <<<"${states2[*]}"))
printf "%s\n" "${sorted[@]}" | sed 's/^/\$/;1i\\' | sed '1i\\' >> ginsimout.cfg
unset IFS

# commenting input istates
for input in $inputs; do
		echo "s:^"$input"\.istate://"$input"\.istate:g" >>sedfile.temp
done
sed -i.temp -f sedfile.temp ginsimout.cfg

# adding inputs as internal and outputs as NOT internal
# inputs are internal so that they are not considered in probtraj file headers
for state in $states; do
	if [[ $inputs == *"$state"* ]]; then
		echo $state | sed "s/$/\.is_internal=1;/" >> internal.temp
	elif [[ $outputs == *"$state"* ]]; then
		echo $state | sed "s/$/\.is_internal=0;/" >> internal.temp
	else
		echo $state | sed "s/$/\.is_internal=1;/" >> internal.temp
	fi
done
sed -i.temp '1i\\' internal.temp


cat internal.temp >> ginsimout.cfg

sed -i.temp '
s/sample_count = 500000/sample_count = 50000/;
s/time_tick = 0.01/time_tick = 0.1/;
s/max_time = 5/max_time = 30/;
' ginsimout.cfg

# some changes to adjust GinSim export to the file used in Cohen et al, PLoS Comp Biol, 2015; doi:10.1371/journal.pcbi.1004571.g003
# cp ginsimout.cfg ginsimout_Cohen.cfg
# sed -i.temp '
# s/sample_count = 500000/sample_count = 50000/;
# s/max_time = 5/max_time = 30/;
# s/time_tick = 0.01/time_tick = 0.1/;
# s/miR200.istate=0/miR200.istate=1/;
# s/miR203.istate=0/miR203.istate=1/;
# s/miR34.istate=0/miR34.istate=1/;
# ' ginsimout_Cohen.cfg

# - modifying BND file
cp ginsimout.bnd ginsimout_original.bnd
names=$(grep Node ginsimout.bnd | sed 's/Node //;s/ {//')
for name in $names; do
if [[ $outputs != *"$name"* ]]; then
sed -i.temp "
s/rate_up = @logic ? \$u_"$name" : 0;/rate_up  = \( \$"$name"_ko ? 0.0 : \( \$"$name"_up ? @max_rate : \( @logic ? \$u_"$name" : 0)));/;
s/rate_down = @logic ? 0 : \$d_"$name";/rate_down  = ( \$"$name"_ko ? @max_rate : ( \$"$name"_up ? 0.0 : ( @logic ? 0 : \$d_"$name")));\\
 \t max_rate = 1.7976931348623157E+308\/1;/" ginsimout.bnd
fi
done



rm *.temp
