#!/usr/bin/bash
sed 's/MaBoSS /MaBoSS2 /' PlMaBoSS_2.0.pl > PlMaBoSS_2.0_Unix.pl
chmod 755 PlMaBoSS_2.0_Unix.pl
./PlMaBoSS_2.0_Unix.pl ginsimout.bnd ginsimout2.cfg
