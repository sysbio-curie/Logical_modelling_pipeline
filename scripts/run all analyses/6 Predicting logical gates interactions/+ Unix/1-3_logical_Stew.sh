#!/usr/bin/bash

java -Xmx6000M -cp '../../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./projectname.cfg -b ./projectname.bnd  -level 1
# java -Xmx6000M -cp '../../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./projectname.cfg -b ./projectname.bnd  -level 2
# java -Xmx6000M -cp '../../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./projectname.cfg -b ./projectname.bnd  -level 2 -several

cd projectname_mutants_logics/
sed -i 's:../MaBoSS:../../../../../lib/MaBoSS:;s:./projectname.cfg:../projectname.cfg:' run.sh
echo "running MaBoSS instances"
chmod 755 run.sh
./run.sh

cd ..

java  -Xmx6000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makelogicmutanttable -folder ./projectname_mutants_logics/ -prefix projectname -out projectname.xls -description ./projectname_mutants_logics/descriptions.txt

java  -Xmx6000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSStatDistFile -folder projectname_mutants_logics/ -prefix projectname -maketable

cd projectname_mutants_logics
for f in *_dist_*; do
	mv $f ../
done
