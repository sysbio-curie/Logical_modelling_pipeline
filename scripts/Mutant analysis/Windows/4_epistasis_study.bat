java -cp ./BiNoM_all.jar;VDAOEngine.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table ginsimout3.xls 
java -cp ./BiNoM_all.jar;VDAOEngine.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout3_norm.dat -phenotype CellCycleArrest -phenotype_short CCA -out ginsimout3 >epistasis_summary.txt
java -cp ./BiNoM_all.jar;VDAOEngine.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout3_norm.dat -phenotype Metastasis -phenotype_short metastasis -out ginsimout3 >>epistasis_summary.txt
java -cp ./BiNoM_all.jar;VDAOEngine.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout3_norm.dat -phenotype EMT -phenotype_short EMT -out ginsimout3 >>epistasis_summary.txt
java -cp ./BiNoM_all.jar;VDAOEngine.jar fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout3_norm.dat -phenotype Apoptosis -phenotype_short apoptosis -out ginsimout3 >>epistasis_summary.txt
mkdir "ginsimout3epistasis"
mv ginsimout3_* ./ginsimout3epistasis/
mv ginsimout3.xls ./ginsimout3epistasis/
mv ginsimout3.xls.dat ./ginsimout3epistasis/
mv epistasis_summary.txt ./ginsimout3epistasis/
mv ProjectName.txt ./ginsimout3epistasis/
