#!/usr/bin/sh

java -cp ./BiNoM.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./metastasis.cfg -b ./metastasis.bnd  -level 2 -several

cd metastasis_mutants_logics/
sed 's:MaBoSS:MaBoSS-1-3-8:;s:./metastasis.cfg:../metastasis.cfg:' run.sh > run2.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh

