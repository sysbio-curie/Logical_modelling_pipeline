#!/usr/bin/sh
java -cp './BiNoM_arnau2.jar:./VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makelogicmutanttable -folder metastasis_mutants_logics/ -prefix metastasis -out metastasis.xls -description metastasis_mutants_logics/descriptions.txt

java -cp './BiNoM_arnau2.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSStatDistFile -folder metastasis_mutants_logics/ -prefix metastasis -maketable
