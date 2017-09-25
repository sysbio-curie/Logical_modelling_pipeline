#!/usr/bin/bash

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
