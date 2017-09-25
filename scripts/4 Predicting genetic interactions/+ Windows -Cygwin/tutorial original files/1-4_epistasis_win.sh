#!/usr/bin/sh

java -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSConfigurationFile -c ./ginsimout.cfg -b ./ginsimout.bnd

cp ./ginsimout.bnd ./ginsimout_mutants/
cd ginsimout_mutants/ 
sed -i 's:../MaBoSS:../../../../lib/MaBoSS.exe:' run.sh
chmod 755 ./run.sh
echo "running MaBoSS instances"
./run.sh

cd ..

java -cp '../../../lib/BiNoM.jar;../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout_mutants/ -prefix ginsimout -out ginsimout.xls

java -cp '../../../lib/BiNoM.jar;../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table ginsimout.xls
java -Xmx4000M -cp '../../../lib/BiNoM.jar;../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype EMT/CellCycleArrest -phenotype_short EMT -out ginsimout >epistasis_summary.txt
java -Xmx4000M -cp '../../../lib/BiNoM.jar;../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype Invasion/EMT/CellCycleArrest -phenotype_short Invasion -out ginsimout >>epistasis_summary.txt
java -Xmx4000M -cp '../../../lib/BiNoM.jar;../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype Apoptosis/CellCycleArrest -phenotype_short Apoptosis -out ginsimout >>epistasis_summary.txt
java -Xmx4000M -cp '../../../lib/BiNoM.jar;../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype Migration/Metastasis/Invasion/EMT/CellCycleArrest -phenotype_short Metastasis -out ginsimout >>epistasis_summary.txt

mkdir "ginsimout_epistasis"
mv ginsimout_* ./ginsimout_epistasis/
mv ginsimout.xls ./ginsimout_epistasis/
mv ginsimout.xls.dat ./ginsimout_epistasis/
mv epistasis_summary.txt ./ginsimout_epistasis/
