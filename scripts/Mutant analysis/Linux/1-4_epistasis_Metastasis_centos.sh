#!/usr/bin/sh

BND=$1
CFG=$2
# 1
perl preprocess.pl $BND $CFG
titol=`head -1 ProjectName.txt`
prefix_mutants=`sed 's/_.*$//' ProjectName.txt | sed 's/$/_mutants/'`
cp epistasis_Metastasis3.sh $titol/
cd $titol
java -cp ../BiNoM_all.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSConfigurationFile -c ./$CFG -b ./$BND
cp ./$BND ./$prefix_mutants/
cd $prefix_mutants/ 
sed 's:\/MaBoSS:\/\.\.\/MaBoSS-1-3-8:' run.sh > run2.sh
rm run.sh
chmod 766 ./run2.sh
echo "running MaBoSS instances"
./run2.sh
cd ..
echo "building MaBoSS results table"
java -Xmx6000M -cp '../BiNoM_all.jar:../VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder $prefix_mutants/ -prefix ginsimout2_ -out $titol.xls
java -Xmx6000M -cp '../BiNoM_all.jar:../VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table $titol.xls 

# check for phenotypes
echo "studying epistasis of selected phenotypes"
norm=$(echo ${titol}_norm)
java -Xmx4000M -cp '../BiNoM_all.jar:../VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table $norm.dat -phenotype CellCycleArrest -phenotype_short CCA -out $titol >epistasis_summary.txt
java -Xmx4000M -cp '../BiNoM_all.jar:../VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table $norm.dat -phenotype Metastasis -phenotype_short metastasis -out $titol >>epistasis_summary.txt
java -Xmx4000M -cp '../BiNoM_all.jar:../VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table $norm.dat -phenotype EMT -phenotype_short EMT -out $titol >>epistasis_summary.txt
java -Xmx4000M -cp '../BiNoM_all.jar:../VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table $norm.dat -phenotype Apoptosis -phenotype_short apoptosis -out $titol >>epistasis_summary.txt
cd ..
rm ProjectName.txt
