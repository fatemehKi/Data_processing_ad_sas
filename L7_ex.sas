
data weights;
   input Program $ s1-s7;
   datalines;
CONT  85 85 86 85 87 86 87
CONT  80 79 79 78 78 79 78
CONT  78 77 77 77 76 76 77
CONT  84 84 85 84 83 84 85
CONT  80 81 80 80 79 79 80
RI    79 79 79 80 80 78 80
RI    83 83 85 85 86 87 87
RI    81 83 82 82 83 83 82
RI    81 81 81 82 82 83 81
RI    80 81 82 82 82 84 86
WI    84 85 84 83 83 83 84
WI    74 75 75 76 75 76 76
WI    83 84 82 81 83 83 82
WI    86 87 87 87 87 87 86
WI    82 83 84 85 84 85 86
;
run;
proc print data=weights; run;


data Patients;
informat Date date7.;
format Date date7. PatientID Z4.;
input PatientID Date Weight @@;
datalines;
1021 04Jan16  302  1042 06Jan16  285
1053 07Jan16  325  1063 11Jan16  291
1053 01Feb16  299  1021 01Feb16  288
1063 09Feb16  283  1042 16Feb16  279
1021 07Mar16  280  1063 09Mar16  272
1042 28Mar16  272  1021 04Apr16  273
1063 20Apr16  270  1053 28Apr16  289
1053 13May16  295  1063 31May16  269
;
RUN;
