#!/usr/bin/bash
java -Xmx6000M -cp '../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSConfigurationFile -c ./ginsimout.cfg -b ./ginsimout.bnd
cp ./ginsimout.bnd ./ginsimout_mutants/
cd ginsimout_mutants/ 
sed -i 's:../MaBoSS:../../../../lib/MaBoSS:' run.sh
chmod 755 ./run.sh
echo "running MaBoSS instances"
 ./run.sh
cd ..
java -Xmx6000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout_mutants/ -prefix ginsimout -out ginsimout.xls
java -Xmx6000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table ginsimout.xls 
java -Xmx4000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype CellCycleArrest -phenotype_short CCA -out ginsimout >epistasis_summary.txt
java -Xmx4000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype Metastasis -phenotype_short metastasis -out ginsimout >>epistasis_summary.txt
java -Xmx4000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype EMT -phenotype_short EMT -out ginsimout >>epistasis_summary.txt
java -Xmx4000M -cp '../../../lib/BiNoM.jar:../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout_norm.dat -phenotype Apoptosis -phenotype_short apoptosis -out ginsimout >>epistasis_summary.txt
mkdir "ginsimout_epistasis"
mv ginsimout_* ./ginsimout_epistasis/
mv ginsimout.xls ./ginsimout_epistasis/
mv ginsimout.xls.dat ./ginsimout_epistasis/
mv epistasis_summary.txt ./ginsimout_epistasis/
