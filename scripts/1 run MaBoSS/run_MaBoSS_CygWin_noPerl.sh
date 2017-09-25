#!/usr/bin/bash
# some changes for a faster and more comprehensive Windows run: unabling multithread, reducing sample_count and extending max_time
sed -i 's/thread_count = 4/thread_count = 1/;s/sample_count = 500000/sample_count = 50000/' ginsimout.cfg
mkdir ginsimout
cp ginsimout.cfg ginsimout/ginsimout.cfg
cp ginsimout.bnd ginsimout/ginsimout.bnd
cd ginsimout
../../../lib/MaBoSS.exe -c ginsimout.cfg -o ginsimout ginsimout.bnd
