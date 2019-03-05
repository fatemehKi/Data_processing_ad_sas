proc sort data=sashelp.class out=c;
   by sex;
run;
 
data anno1;
   retain x1 20 y1 85 function 'Text' dataspace 'GraphPercent' width 100;
   label = 'Students'; output;
run;
 title ' ';
 footnote ' ';
proc sgplot data=c sganno=anno1 tmplout='tmp';
   scatter y=weight x=height;
   by sex;
run;

/* The SGANNO= option specifies the name of a SAS data set that containsannotation instructions. */

data c2;
   set c;
   by sex;
   if first.sex and sex eq 'F' then do;
      x1 = 51;   y1 = 104; Label = 'Female';
      end;
   else if first.sex and sex eq 'M' then do;
      x1 = 56;   y1 = 140; Label = 'Male';
      end;
   else call missing(label,x1,y1);
run;
 proc sgplot data=c sganno=anno1 tmplout='tmp';
   scatter y=weight x=height;
   by sex;
run;
proc sgplot data=c2;
   scatter y=weight x=height;
   text y=y1 x=x1 text=label;
   by sex;
run;

/**** L ****/
data chocolate;
  input agegroup $ favorite $ @@;
datalines;
A pear A 80%cacao A earlgrey C 80%cacao A ginger C pear
C 80%cacao C pear C pear A earlgrey A 80%cacao C 80%cacao
A ginger A pear C earlgrey C 80%cacao A 80%cacao A earlgrey
A 80%cacao C pear C pear A 80%cacao C pear C 80%cacao
;
run;

proc format;
  value $age 
        'A'='Adult'
		'C'='Child';
run;
proc print data=chocolate;
  format agegroup $age.;
run;
/*
ODS GRAPHICS ON;
GOPTION RESET=ALL;
*/

TITLE "GENERATING A VERTICAL BAR CHAR USING PROC SGPLOT";

proc sgplot data=sashelp.class ;
  hbar sex;
  /*
  format agegroup $age.;
  label favorite='Flavor of Chocolate';
  title2 'Bar chart for favorite flavor';
  */
run;


data contest;
  input name $ num_books @@;
datalines;
bella 4 anthony 9 joe 10 chris 6 beth 5 daniel 2
david 7 emily 7 josh 7 will 9 olivia 7 matt 8
maddy 8 sam 13 jessica 6 jose 6 mia 12 elliott 8
tyler 15 lauren 10 cate 14 ava 11 mary 9 eric 10
megan 13 michael 9 john 18 alex 5 cody 11 amy 4
;
run;

title "Generating a Histogram Using Proc SGPLOT";
proc sgplot data=contest;
histogram num_books/showbins scale=count;
density num_books/type=normal ; 
title2 'Reading Contest';
run;

proc plot data=sashelp.class;
  plot height*weight;
run;

data bikerace;
  input division $ num_laps @@;
datalines;
adult 44 adult 33 youth 33 masters 38 adult 40
masters 32 youth 32 youth 38 youth 33 adult 47
masters 37 masters 46 youth 34 adult 42 youth 24
masters 33 adult 44 youth 35 adult 49 adult 38
adult 39 adult 42 adult 32 youth 42 youth 70
masters 33 adult 33 masters 32 youth 37 masters 40
;
run;

ods pdf file="C:\test\bike_result.pdf";
title "Create Plot";
proc sgplot data=bikerace;
  HBOX num_laps/category=division;
  title2 "Results by Division";
run;
ods pdf close;

data wings;
  input name $13. type $ length wingspan @@ ;
datalines;
robin         s 28  41   bald eagle   r 102 244  barn owl      r 50 110 
osprey        r 66  180  cardinal     s 23  31   goldfinch     s 11 19
golden eagle  r 100 234  crow         s 53  100  magpie        s 60 60
elf owl       r 15  27   condor       r 140 300
;
run;
proc print; run;

proc format;
  value $birdtype
        's'='songbirds'
		'r'='raptors';
run;
proc sgplot data=wings;
  scatter x=wingspan y=length /group=type;
  format type $birdtype.;
  title 'Comparison of Wingspan vs. Length';
run;

goptions reset=all;
title "Generating a pie chart";
proc gchart data=sashelp.cars;
  pie type/discrete value=inside
           percent=inside slice=inside;
run;

DATA TRAVEL;
  INPUT COUNTRY $12. AIRCOST VENDOR $9. NUM_PEOPLE;
CARDS;
France       575 Express  10
Spain        510 World    12
Brazil       540 World     6
India        489 Express   .
Japan        720 Express  10
Greece       698 Express  20
New Zealand 1489 Southsea  6
Venezuela    425 World     8
Italy        468 Express   9
USSR         924 World     6
Switzerland  734 World    20
Australia   1079 Southsea 10
Ireland      558 Express   9
;
RUN;

ods pdf file="C:\SAS Course\SAS Advanced_Final\data\aircost.pdf";
title "Air Cost Plot";
proc sgplot data=travel;
  HBOX aircost/category=country;
  title2 "Results by Contry";
run;
ods pdf close;

ods pdf file="C:\SAS Course\SAS Advanced_Final\data\aircost1.pdf";
title "Air Cost Plot";
proc sgplot data=travel;
histogram aircost/showbins scale=count;
density aircost/type=normal ;
title2 "Results by Contry";
run;
ods pdf close;

data fan;                                     
      input lifetime censor $ @@;                   
      lifetime = lifetime / 1000;                
      datalines;                                 
       450 0    460 1   1150 0   1150 0   1560 1 
      1600 0   1660 1   1850 1   1850 1   1850 1 
      1850 1   1850 1   2030 1   2030 1   2030 1 
      2070 0   2070 0   2080 0   2200 1   3000 1 
      3000 1   3000 1   3000 1   3100 0   3200 1 
      3450 0   3750 1   3750 1   4150 1   4150 1 
      4150 1   4150 1   4300 1   4300 1   4300 1 
      4300 1   4600 0   4850 1   4850 1   4850 1 
      4850 1   5000 1   5000 1   5000 1   6100 1 
      6100 0   6100 1   6100 1   6300 1   6450 1 
      6450 1   6700 1   7450 1   7800 1   7800 1 
      8100 1   8100 1   8200 1   8500 1   8500 1 
      8500 1   8750 1   8750 0   8750 1   9400 1 
      9900 1  10100 1  10100 1  10100 1  11500 1 
      ;                                          
   run;
ods pdf file="C:\SAS Course\SAS Advanced_Final\data\fan.pdf";
proc sgplot data=fan;
  HBOX lifetime/category=censor;
  title ' ';
  title2 " ";
run;
ods pdf close;






