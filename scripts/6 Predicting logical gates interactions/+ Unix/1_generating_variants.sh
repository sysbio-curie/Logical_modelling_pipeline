#!/usr/bin/bash

java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 1
# java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 2
# java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSBNDFile -c ./ginsimout.cfg -b ./ginsimout.bnd  -level 2 -several
