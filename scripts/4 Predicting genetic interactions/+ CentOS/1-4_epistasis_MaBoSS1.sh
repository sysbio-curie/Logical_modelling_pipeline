#!/usr/bin/sh
java -cp ./BiNoM.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSConfigurationFile -c ./ginsimout.cfg -b ./ginsimout.bnd
cp ./ginsimout.bnd ./ginsimout_mutants/
cd ginsimout_mutants/ 
sed 's/MaBoSS/MaBoSS-1-3-8/' run.sh > run2.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
cd ..
java -Xmx6000M -cp './BiNoM.jar:./VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout_mutants/ -prefix ginsimout -out ginsimout.xls
java -Xmx6000M -cp './BiNoM.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table ginsimout.xls
java -Xmx4000M -cp './BiNoM.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype CellCycleArrest -phenotype_short CCA -out ginsimout >epistasis_summary.txt

