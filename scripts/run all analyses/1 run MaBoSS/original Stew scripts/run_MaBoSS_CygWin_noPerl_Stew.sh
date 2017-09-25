#!/usr/bin/bash
# some changes for a faster and more comprehensive Windows run: unabling multithread, reducing sample_count and extending max_time
sed -i 's/thread_count = 4/thread_count = 1/;s/sample_count = 500000/sample_count = 50000/' projectname.cfg 
mkdir projectname
cp projectname.cfg projectname/projectname.cfg
cp projectname.bnd projectname/projectname.bnd
cd projectname
../../../lib/MaBoSS.exe -c projectname.cfg -o projectname projectname.bnd
