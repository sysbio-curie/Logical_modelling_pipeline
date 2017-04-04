#!/usr/bin/sh

cp ./ginsimout.bnd ./ginsimout_mutants/
cd ginsimout_mutants/ 
echo "running MaBoSS instances"
./run.sh
