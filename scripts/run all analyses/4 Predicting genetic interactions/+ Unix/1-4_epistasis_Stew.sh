#!/usr/bin/bash
java -Xmx6000M -cp '../../../../lib/BiNoM.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSConfigurationFile -c ./projectname.cfg -b ./projectname.bnd
cp ./projectname.bnd ./projectname_mutants/
cd projectname_mutants/ 
sed -i 's:../MaBoSS:../../../../../lib/MaBoSS:' run.sh
chmod 755 run.sh
echo "running MaBoSS instances"
./run.sh
cd ..
java -Xmx6000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder projectname_mutants/ -prefix projectname -out projectname.xls
java -Xmx6000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table projectname.xls 
java -Xmx4000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table projectname_norm.dat -phenotype CellCycleArrest -phenotype_short CCA -out projectname >epistasis_summary.txt
java -Xmx4000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table projectname_norm.dat -phenotype Metastasis -phenotype_short metastasis -out projectname >>epistasis_summary.txt
java -Xmx4000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table projectname_norm.dat -phenotype EMT -phenotype_short EMT -out projectname >>epistasis_summary.txt
java -Xmx4000M -cp '../../../../lib/BiNoM.jar:../../../../lib/VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table projectname_norm.dat -phenotype Apoptosis -phenotype_short apoptosis -out projectname >>epistasis_summary.txt
mkdir "projectname_epistasis"
mv projectname_* ./projectname_epistasis/
mv projectname.xls ./projectname_epistasis/
mv projectname.xls.dat ./projectname_epistasis/
mv epistasis_summary.txt ./projectname_epistasis/
cp projectname_epistasis/projectname_norm.xls ../../"5 Analyses of genetic interactions"/
