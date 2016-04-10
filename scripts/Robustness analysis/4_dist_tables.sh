#!/usr/bin/bash
DIST=$1

grep WT "$DIST"_dist_mutants_count.txt | cut -d$'\t' -f-4 | cut -d$'\t' -f3- > wt.temp
grep -v WT "$DIST"_dist_mutants_count.txt | sed 's/\t$//' > a.temp
tail -n +2 a.temp | cut -d$'\t' -f-4 | cut -d$'\t' -f3- > mutant.temp

perl hamm_dist.pl

echo "DIST_TO_WT	Closest_WT" >> b.temp
cut -d$'\t' -f2- report.temp | awk 'BEGIN {FS=OFS="\t"} {print $2 OFS $1}' >> b.temp
paste a.temp b.temp > "$DIST"_dist_mutants_WTdist.txt

cut -d$'\t' -f4- "$DIST"_dist_mutants_WTdist.txt | awk 'BEGIN {FS=OFS="\t"} {a=$1; b=$(NF-2); $1=$(NF-2)=""; print a, b, $0}' | sed 's/\t\t/\t/g;s/\t$//' | awk 'NR==1; NR > 1 {print $0 | "sort -nr -k 2 | uniq"}'>"$DIST"_counts_sorted.txt

rm *.temp
