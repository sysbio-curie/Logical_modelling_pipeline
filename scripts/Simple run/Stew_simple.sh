#!/bin/bash
# script built for the automatic stewardship of project names in the pipeline

# State your project name inside the quote:
projectname="PKN"

# Define inputs and outputs in one TXT file each (needed for _ko and _up parameters of epistasis and for is_internal parameters of MaBoSS
# name of TXT file that describes inputs (one input per line)
listIn="inputs"
# name of TXT file that describes outputs (one output per line)
listOut="outputs"

cp ./{"$projectname".bnd,"$projectname".cfg,"$listOut".txt,"$listIn".txt} ./"1 run MaBoSS"/

# Run MaBoSS instance
echo "run MaBoSS instance"
cd "1 run MaBoSS"
sed "
s/projectname/"$projectname"/g;
s/listIn/"$listIn"/g;
s/listOut/"$listOut"/g
" BND_CFG_modif_Stew.sh >BND_CFG_modif_Stew_post.sh
sed "s/projectname/"$projectname"/g" run_MaBoSS_Unix_Stew.sh >run_MaBoSS_Unix_Stew_post.sh
chmod 755 BND_CFG_modif_Stew_post.sh run_MaBoSS_Unix_Stew_post.sh
./BND_CFG_modif_Stew_post.sh
./run_MaBoSS_Unix_Stew_post.sh

# Copy files needed for other sections of the pipeline
echo "Copy files needed for other sections of the pipeline"
cp $projectname/"$projectname"_fp.csv ../"2 PCA on ss"/
cp $projectname/"$projectname"_probtraj_table.csv ../"3 Displaying asymptotic solutions"/
# Principal Component Analysis of asymptotic solutions of model
echo "Principal Component Analysis of asymptotic solutions"
cd ../"2 PCA on ss"
sed "s/projectname/"$projectname"/g" PCA_on_FixedPoints_Stew.R >PCA_on_FixedPoints_Stew_post.R
chmod 755 PCA_on_FixedPoints_Stew_post.R
Rscript PCA_on_FixedPoints_Stew_post.R
mv Rplots.pdf PCA_on_FixedPoints_plots.pdf

# Displaying asymptotic solutions of model
echo "Displaying asymptotic solutions"
cd ../"3 Displaying asymptotic solutions"
sed "s/projectname/"$projectname"/g" Displaying_asymptotic_solutions_Stew.R > Displaying_asymptotic_solutions_Stew_post.R
chmod 755 Displaying_asymptotic_solutions_Stew_post.R
Rscript Displaying_asymptotic_solutions_Stew_post.R
mv Rplots.pdf Displaying_asymptotic_solutions_plots.pdf

