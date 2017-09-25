#!/usr/bin/bash
# script built for the automatic stewardship of project names in the pipeline

# State your project name inside the quote:
projectname="booleanmodel"

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
# following lines in case you want to use this script on Cygwin
# sed "s/projectname/"$projectname"/g" run_MaBoSS_CygWin_Stew.sh >run_MaBoSS_CygWin_Stew_post.sh
# sed "s/projectname/"$projectname"/g" run_MaBoSS_CygWin_noPerl_Stew.sh >run_MaBoSS_CygWin_noPerl_Stew_post.sh
# chmod 755 BND_CFG_modif_Stew_post.sh run_MaBoSS_CygWin_Stew_post.sh run_MaBoSS_CygWin_noPerl_Stew_post.sh 
# ./BND_CFG_modif_Stew_post.sh
# ./run_MaBoSS_CygWin_Stew_post.sh

# Copy files needed for other sections of the pipeline
echo "Copy files needed for other sections of the pipeline"
cp $projectname/"$projectname"_fp.csv ../"2 PCA on ss"/
cp $projectname/"$projectname"_probtraj_table.csv ../"3 Displaying asymptotic solutions"/
cp $projectname/"$projectname".bnd ../"4 Predicting genetic interactions"/"+ Unix"/
cp $projectname/"$projectname".cfg ../"4 Predicting genetic interactions"/"+ Unix"/
cp $projectname/"$projectname"_probtraj_table.csv ../"5 Analyses of genetic interactions"/
cp $projectname/"$projectname".bnd ../"6 Predicting logical gates interactions"/"+ Unix"/
cp $projectname/"$projectname".cfg ../"6 Predicting logical gates interactions"/"+ Unix"/
cp $projectname/"$projectname"_probtraj_table.csv ../"7 Analyses of logical gates"/

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

# Predict genetic interactions of the model
echo "Predict genetic interactions of the model"
cd ../"4 Predicting genetic interactions"/"+ Unix"/
sed "s/projectname/"$projectname"/g" 1\-4_epistasis_Stew.sh > 1\-4_epistasis_Stew_post.sh
chmod 755 1\-4_epistasis_Stew_post.sh
./1-4_epistasis_Stew_post.sh
# cp "$projectname"_epistasis/"$projectname"_norm.xls ../../"5 Analyses of genetic interactions"/

# Analyse genetic interactions of the model
echo "Analyse genetic interactions of the model"
cd ../../"5 Analyses of genetic interactions"/
sed "s/projectname/"$projectname"/g" Analyses_of_genetic_interactions_Stew.R > Analyses_of_genetic_interactions_Stew_post.R
chmod 755 Analyses_of_genetic_interactions_Stew_post.R
Rscript Analyses_of_genetic_interactions_Stew_post.R
mv Rplots.pdf Analyses_of_genetic_interactions_plots.pdf

# Predict logical gates variants of the model
echo "Predict logical gates variants of the model"
cd ../"6 Predicting logical gates interactions"/"+ Unix"/
sed "s/projectname/"$projectname"/g" 1\-3_logical_Stew.sh > 1\-3_logical_Stew_post.sh
chmod 755 1\-3_logical_Stew_post.sh
./1-3_logical_Stew_post.sh
cp ./{"$projectname".xls,"$projectname"_dist_mutants_Hamming.txt} ../../"7 Analyses of logical gates"/

# Analyse logical gates variants perturbations of the model
echo "Analyse logical gates variants perturbations of the model"
cd ../../"7 Analyses of logical gates"/
sed "s/projectname/"$projectname"/g" Analyses_of_logical_gates_Stew.R > Analyses_of_logical_gates_Stew_post.R
chmod 755 Analyses_of_logical_gates_Stew_post.R
Rscript Analyses_of_logical_gates_Stew_post.R
mv Rplots.pdf Analyses_of_logical_gates_plots.pdf
