#!/usr/bin/sh

cp ./ginsimout.bnd ./ginsimout_mutants/
cd ginsimout_mutants/ 
sed 's/MaBoSS/MaBoSS-1-3-8/' run.sh > run2.sh
# rm run.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
