#!/usr/bin/bash
java -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makelogicmutanttable -folder ./ginsimout_mutants_logics/ -prefix ginsimout -out ginsimout.xls -description ./ginsimout_mutants_logics/descriptions.txt

java -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSStatDistFile -folder ginsimout_mutants_logics/ -prefix ginsimout -maketable
