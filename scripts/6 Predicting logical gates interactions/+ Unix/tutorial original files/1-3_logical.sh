#!/usr/bin/bash

java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 1
# java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 2
# java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 2 -several

cd ginsimout_mutants_logics/
sed -i 's:../MaBoSS:../../../../lib/MaBoSS:;s:./ginsimout.cfg:../ginsimout.cfg:' run.sh
echo "running MaBoSS instances"
chmod 755 run.sh
./run.sh

cd ..

java -Xmx6000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makelogicmutanttable -folder ./ginsimout_mutants_logics/ -prefix ginsimout -out ginsimout.xls -description ./ginsimout_mutants_logics/descriptions.txt

java -Xmx6000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSStatDistFile -folder ginsimout_mutants_logics/ -prefix ginsimout -maketable

cd ginsimout_mutants_logics
for f in *_dist_*; do
	mv $f ../
done
