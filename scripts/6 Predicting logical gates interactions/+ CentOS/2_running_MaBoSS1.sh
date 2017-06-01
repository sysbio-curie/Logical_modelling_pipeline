#!/usr/bin/sh

cd ginsimout_mutants_logics/
sed 's:MaBoSS:MaBoSS-1-3-8:;s:./ginsimout.cfg:../ginsimout.cfg:' run.sh > run2.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh

