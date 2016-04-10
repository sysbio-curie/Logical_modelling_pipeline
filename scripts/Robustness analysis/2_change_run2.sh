#!/usr/bin/sh

cd metastasis_mutants_logics/
sed 's:MaBoSS:MaBoSS-1-3-8:;s:./metastasis.cfg:../metastasis.cfg:' run.sh > run2.sh
# rm run.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
