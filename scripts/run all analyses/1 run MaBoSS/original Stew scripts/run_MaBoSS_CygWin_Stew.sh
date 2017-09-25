#!/usr/bin/bash
# some changes for a faster and more comprehensive Windows run: unabling multithread, reducing sample_count and time_tick.
sed -i 's/thread_count = 4/thread_count = 1/' projectname.cfg
# mv ginsimout2.cfg ginsimout.cfg
./PlMaBoSS_2.0_CygWin.pl projectname.bnd projectname.cfg
