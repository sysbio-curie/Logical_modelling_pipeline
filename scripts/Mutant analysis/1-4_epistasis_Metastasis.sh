#!/usr/bin/sh

# files needed: 
# - perl.pl --> ara és preprocess.pl
# - BiNoM_all.jar
# - MaBoSS-1-3-8
# - VDAOEngine.jar
# - BND file ($1)
# - CFG file ($2)
# BiNoM_all or BiNoM_beta??
BND=$1
CFG=$2
# 1
perl preprocess.pl $BND $CFG
titol=`head -1 ProjectName.txt`
prefix_mutants=`sed 's/_.*$//' ProjectName.txt | sed 's/$/_mutants/'`
cp epistasis_Metastasis2.sh $titol/
cd $titol
java -cp ../BiNoM_beta.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSConfigurationFile -c ./$CFG -b ./$BND
cd $prefix_mutants/ 
sed 's/MaBoSS/MaBoSS-1-3-8/' run.sh > run2.sh
echo "copying to perso"
./run2.sh
# 2
echo "copying MaBoSS results from perso"
cp -pr X:/maboss/$titol/*.csv ./
cp -pr X:/maboss/$titol/*.txt ./
cd ..

java -classpath '../BiNoM_all.jar;../VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout2_mutants/ -prefix ginsimout2_ -out ginsimout2.xls
java -classpath '../BiNoM_beta.jar;../VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -maketable -folder ginsimout2_mutants/ -prefix ginsimout2_ -out ginsimout2_beta.xls

# 3
java -Xmx6000M -classpath '../BiNoM_beta.jar;../VDAOEngine.jar' fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table $titol.xls 
