# Readme file for Stew.sh

> Arnau Montagud, 21 September 2017
> contact: arnau.montagud@curie.fr

Stew.sh is a script that automatises the different sections of the pipeline and retrieves basic plots with most probable phenotypes. It is meant to be used together with the docker image provided and thus uses Unix scripts. 
If users want to dig into a specific study or phenotype (or if they want to replicate the figures presented in the manuscript or the tutorial), they should head to the section of interest and modify the scripts to their liking.

Stew.sh only needs four files to run all the analyses:
- BND file
- CFG file
- TXT file, where all inputs are described, one per line
- TXT file, where all outputs are described, one per line

Once you have all four files in this folder, modify the first lines of Stew.sh to define your project name (should be the name of the BND and CFG file) and the name of the input and output files.
In present example, our project name will be "booleanmodel", our input file name will be "inputs" and our output file name will be "outputs".
