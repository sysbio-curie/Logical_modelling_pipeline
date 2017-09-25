#!/usr/bin/bash

cd ginsimout_mutants_logics/
sed 's:./ginsimout.cfg:../ginsimout.cfg:' run.sh > run2.sh
chmod 755 ./run2.sh
echo "running MaBoSS instances"
./run2.sh

# In Windows, MaBoSS.exe does not produce FP file, this code hereby does it:
for f in *_statdist*; do
	echo "Processing FP of $f"
	sed -n '/Fixed Points/,$p' $f > $f.temp
	Pheno=$(sed -n '2p' $f.temp | cut -f3-)
	name=$(sed 's:statdist\.csv\.temp:fp\.csv:' <<<"$f.temp")
	sed '1,2d' $f.temp | cut -f3- > FP.temp
	printf "\nState\n" > State.temp
		while read p; do
			unset var
			array=($p)
			arrayB=($Pheno)
			count=${#array[@]}
			index=0
			while [ "$index" -lt "$count" ]; do
				if [ "${array[$index]}" = "1" ]; then
				var=$(echo -e $var${arrayB[$index]}"\t")
				fi
				let "index++"
			done
				echo "$var" >> State.temp
		done <FP.temp
	paste $f.temp <(sed 's:\t$::g;s: : \-\- :g' State.temp) | awk -F '\t' -v OFS="\t" '{$3=$NF OFS $3;$NF=""}1' | sed 's:\t\t::;s:\t$::' > $name
rm -f *.temp
done
