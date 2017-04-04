#!/usr/bin/bash
sed 's/MaBoSS /MaBoSS-1-3-8 /' PlMaBoSS_2.0.pl > PlMaBoSS_2.0_Unix.pl
chmod 755 PlMaBoSS_2.0_Unix.pl
./PlMaBoSS_2.0_Unix.pl ginsimout.bnd ginsimout2.cfg
