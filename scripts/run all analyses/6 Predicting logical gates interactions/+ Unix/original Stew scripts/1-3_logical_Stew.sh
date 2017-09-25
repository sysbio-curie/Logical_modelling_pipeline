#!/usr/bin/bash

java -cp '../../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./projectname.cfg -b ./projectname.bnd  -level 1

cd projectname_mutants_logics/
# sed 's:../MaBoSS:../../../../../lib/MaBoSS:;s:./projectname.cfg:../projectname.cfg:' run.sh > run2.sh
# chmod 766 ./run2.sh
sed -i 's:../MaBoSS:../../../../../lib/MaBoSS:;s:./projectname.cfg:../projectname.cfg:' run.sh
echo "running MaBoSS instances"
./run.sh
# ./run2.sh

cd ..

java -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makelogicmutanttable -folder ./projectname_mutants_logics/ -prefix projectname -out projectname.xls -description ./projectname_mutants_logics/descriptions.txt

java -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSStatDistFile -folder projectname_mutants_logics/ -prefix projectname -maketable

cd projectname_mutants_logics
for f in *_dist_*; do
	mv $f ../
done
