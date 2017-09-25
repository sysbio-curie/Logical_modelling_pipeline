#!/usr/bin/bash

cd ginsimout_mutants_logics/
sed 's:../MaBoSS:../../../../lib/MaBoSS:;s:./ginsimout.cfg:../ginsimout.cfg:' run.sh > run2.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
