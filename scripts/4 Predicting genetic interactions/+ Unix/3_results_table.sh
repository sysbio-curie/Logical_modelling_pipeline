#!/usr/bin/bash
java -Xmx6000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout_mutants/ -prefix ginsimout -out ginsimout.xls
