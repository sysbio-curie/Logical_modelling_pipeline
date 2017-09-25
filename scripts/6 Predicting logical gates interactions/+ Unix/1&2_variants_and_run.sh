#!/usr/bin/bash

java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 1
# java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 2
# java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 2 -several

cd ginsimout_mutants_logics/
sed 's:../MaBoSS:../../../../lib/MaBoSS:;s:./ginsimout.cfg:../ginsimout.cfg:' run.sh > run2.sh
chmod 755 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
