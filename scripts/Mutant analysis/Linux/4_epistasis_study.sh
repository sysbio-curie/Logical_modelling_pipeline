#!/usr/bin/sh

java -Xmx6000M -cp './BiNoM_all.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -normtable -table ginsimout2.xls 
java -Xmx4000M -cp './BiNoM_all.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout2_norm.dat -phenotype CellCycleArrest -phenotype_short CCA -out ginsimout2 >epistasis_summary.txt
java -Xmx4000M -cp './BiNoM_all.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout2_norm.dat -phenotype Metastasis -phenotype_short metastasis -out ginsimout2 >>epistasis_summary.txt
java -Xmx4000M -cp './BiNoM_all.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout2_norm.dat -phenotype EMT -phenotype_short EMT -out ginsimout2 >>epistasis_summary.txt
java -Xmx4000M -cp './BiNoM_all.jar:./VDAOEngine.jar'  fr.curie.BiNoM.pathways.MaBoSS.MaBoSSProbTrajFile -makeinter -table ginsimout2_norm.dat -phenotype Apoptosis -phenotype_short apoptosis -out ginsimout2 >>epistasis_summary.txt
mkdir "ginsimout2epistasis"
mv ginsimout2_* ./ginsimout2epistasis/
mv ginsimout2.xls ./ginsimout2epistasis/
mv ginsimout2.xls.dat ./ginsimout2epistasis/
mv epistasis_summary.txt ./ginsimout2epistasis/
mv ProjectName.txt ./ginsimout2epistasis/
