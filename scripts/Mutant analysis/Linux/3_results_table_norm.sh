#!/usr/bin/sh
java -Xmx6000M -cp './BiNoM_all.jar:./VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout2_mutants/ -prefix ginsimout2_ -out ginsimout2.xls
