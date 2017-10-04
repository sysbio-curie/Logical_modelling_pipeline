Supplementary table 1: Performance tests of the different parts of logical modelling framework

| Pipeline section | Script | Unix | Docker on Windows OS | Docker on Mac OS | Cygwin on Windows OS |
|:------------------------------------------------------------------------------:|:----------------------------------------------:|:------------:|:--------------------:|:----------------:|:--------------------:|
| MaBoSS simulations | BND\_CFG\_modif.sh | 1.116s | 0.545s | TBA | 4.818s |
| MaBoSS simulations | MaBoSS environment (using MBSS\_FormatTable.pl) | 5.543s | 12.024s | 1.233s | 14.206s |
| MaBoSS simulations | run\_MaBoSS\_Unix.sh | 5.109s | 10.876s | TBA | - |
| MaBoSS simulations | run\_MaBoSS\_CygWin.sh | - | - | - | 14.375s |
| MaBoSS simulations | run\_MaBoSS\_CygWin\_noPerl.sh | - | - | - | 15.092s |
| Analysis of stable solutions; Principal component analysis | PCA\_on\_FixedPoints.R | 3.441s | 3.481s | 3.607s | 9s |
| Analysis of stable solutions; Displaying asymptotic solutions | Displaying asymptotic solutions.R | 4.116s | 2.5s | 2.404s | 4.506s |
| Mutant analysis; Predicting genetic interactions | 1-4\_epistasis.sh (1352 mutants) | 124m 5.477s | 201m 10.858s | TBA | 414m 20.224s |
| Mutant analysis; Predicting genetic interactions and Robustness analysis | Analyses\_of\_genetic\_interactions.R | 5.12s | 8.041s | TBA | 4.326s |
| Mutant analysis; Predicting logical gates interactions | 1-3\_logical.sh; level 1(360 variants) | 29m 8.752s | 77m 40.512s | TBA | 85m 3.215s |
| Mutant analysis; Predicting logical gates interactions | 1-3\_logical.sh; level 2 (4387 variants) | 474m 39.519s | 944m 52.755s | TBA | 1052m 6.628s |
| Mutant analysis; Predicting logical gates interactions and Robustness analysis | Analyses\_of\_logical\_gates.R | 3.919s | 3.13s | TBA | 4.761s |
| All the pipeline | Stew.sh | 181m 3.503s | 351m 23.514s | TBA | - |


Windows machine was an Intel Core i7-4800MQ, CPU @ 2.70 GHz, and 8GB RAM, running Windows 7 Pro x64.

Unix machine was an Intel Core i5-5250U, CPU @ 1.60 GHz, and 16GB RAM, running CentOS 7 x64.

Mac machine was an Intel Core i5-3427U, CPU @ 1.80 GHz, and 4GB RAM, running MacOS X El Capitan x64.

Docker container was build to use default allocated memory (1GB).
