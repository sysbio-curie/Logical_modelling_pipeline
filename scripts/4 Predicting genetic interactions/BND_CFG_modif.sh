#!/usr/bin/sh

# - modifying CFG file
# Define outputs in file called "listOut" (needed for _ko and _up parameters of epistasis) and inputs in file called "listIn" (needed for is_internal parameters of MaBoSS), one output per line
states=$(grep istate ginsimout.cfg)
outputs=$(sed ':a;N;$!ba;s/\n/ /g;s/^/ /g' listOut.txt)
inputs=$(sed ':a;N;$!ba;s/\n/ /g;s/^/ /g' listIn.txt)

cp ginsimout.cfg ginsimout_original.cfg
state_ko=$(echo $states | sed 's/.istate/_ko/g')
state_up=$(echo $states | sed 's/.istate/_up/g')
states2=$(printf "%s\n" ${state_ko[@]} ${state_up[@]})
IFS=$'\n' sorted=($(sort <<<"${states2[*]}"))
printf "%s\n" "${sorted[@]}" | sed 's/^/\$/;1i\\' | sed '1i\\' >> ginsimout.cfg
unset IFS

# commenting input istates
for input in $inputs; do
		echo "s:^"$input"\.istate://"$input"\.istate:g" >>sedfile.temp
done
sed -i -f sedfile.temp ginsimout.cfg

# adding inputs as internal and outputs as NOT internal
# inputs are internal so that they are not considered in probtraj file headers
for state in $states; do
	state2=$(echo $state | sed 's/\.istate=0;//')
	if [[ $inputs == *"$state2"* ]]; then
		echo $state | sed "s/\.istate=0/\.is_internal = 1/" >> internal.temp
	elif [[ $outputs == *"$state2"* ]]; then
		echo $state | sed "s/\.istate=0/\.is_internal = 0/" >> internal.temp
	else
		echo $state | sed "s/\.istate=0/\.is_internal = 1/" >> internal.temp
	fi
done
sed -i '1i\\' internal.temp

cat internal.temp >> ginsimout.cfg

rm *.temp

sed -i '
s/sample_count = 500000/sample_count = 50000/;
s/time_tick = 0.01/time_tick = 0.1/;
s/max_time = 5/max_time = 30/;
' ginsimout.cfg

# some changes to adjust GinSim export to the file used in Cohen et al, PLoS Comp Biol, 2015; doi:10.1371/journal.pcbi.1004571.g003
# cp ginsimout.cfg ginsimout_Cohen.cfg
# sed -i '
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
sed -i "
s/rate_up = @logic ? \$u_"$name" : 0;/rate_up  = \( \$"$name"_ko ? 0.0 : \( \$"$name"_up ? @max_rate : \( @logic ? \$u_"$name" : 0)));/;
s/rate_down = @logic ? 0 : \$d_"$name";/rate_down  = ( \$"$name"_ko ? @max_rate : ( \$"$name"_up ? 0.0 : ( @logic ? 0 : \$d_"$name")));\\
 \t max_rate = 1.7976931348623157E+308\/1;/" ginsimout.bnd
fi
done
