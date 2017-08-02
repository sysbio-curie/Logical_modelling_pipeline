#!/usr/bin/bash
# some changes for a faster and more comprehensive Windows run: unabling multithread, reducing sample_count and extending max_time
sed 's/thread_count = 4/thread_count = 1/;s/sample_count = 500000/sample_count = 50000/' ginsimout.cfg > ginsimout2.cfg
mv ginsimout2.cfg ginsimout.cfg
mkdir ginsimout
cp ginsimout.cfg ginsimout/ginsimout.cfg
cp ginsimout.bnd ginsimout/ginsimout.bnd
cd ginsimout
../../../lib/MaBoSS2 -c ginsimout.cfg -o ginsimout ginsimout.bnd

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
