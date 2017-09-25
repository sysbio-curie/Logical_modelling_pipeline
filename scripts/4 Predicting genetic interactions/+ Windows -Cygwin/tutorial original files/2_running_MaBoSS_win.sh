#!/usr/bin/sh

cp ./ginsimout.bnd ./ginsimout_mutants/
cd ginsimout_mutants/ 
sed 's:../MaBoSS:../../../../lib/MaBoSS.exe:' run.sh > run2.sh
chmod 755 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
