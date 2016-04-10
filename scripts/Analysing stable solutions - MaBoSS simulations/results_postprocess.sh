#!/usr/bin/bash

transpose () {
awk '
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {    
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str"	"a[i,j];
        }
        print str
    }
}'
}

name=$(echo "$1" | sed s/.csv//)
lastcol=$(wc -l <$1)
cat $name.csv | transpose | sed 's/Err.*$//' | sed '/^$/d' >a1.temp
head -n 3 <a1.temp > a2.temp
tail -n +4 <a1.temp | sort -r -n -k$lastcol >> a2.temp 
cat a2.temp | transpose > "$name"_post.txt
rm *.temp
