/* Part I : Procedures */
/* PROC REPORT */
data grain_production;
   length Country $ 3 Type $ 5;
   input Year country $ type $ Kilotons;
   datalines;
1995 BRZ  Wheat    1516
1995 BRZ  Rice     11236
1995 BRZ  Corn     36276
1995 CHN  Wheat    102207
1995 CHN  Rice     185226
1995 CHN  Corn     112331
1995 IND  Wheat    63007
1995 IND  Rice     122372
1995 IND  Corn     9800
1995 INS  Wheat    .
1995 INS  Rice     49860
1995 INS  Corn     8223
1995 USA  Wheat    59494
1995 USA  Rice     7888
1995 USA  Corn     187300
1996 BRZ  Wheat    3302
1996 BRZ  Rice     10035
1996 BRZ  Corn     31975
1996 CHN  Wheat    109000
1996 CHN  Rice     190100
1996 CHN  Corn     119350
1996 IND  Wheat    62620
1996 IND  Rice     120012
1996 IND  Corn     8660
1996 INS  Wheat    .
1996 INS  Rice     51165
1996 INS  Corn     8925
1996 USA  Wheat    62099
1996 USA  Rice     7771
1996 USA  Corn     236064
;
RUN;

proc format;
   value $cntry 'BRZ'='Brazil'
                'CHN'='China'
                'IND'='India'
                'INS'='Indonesia'
                'USA'='United States';
run;
options nobyline;
title 'Leading Grain-Producing Countries';
title2 'for #byval(year)';
 
proc report data=grain_production /*nowindows*/
     headline headskip;
   by year;
   column country type kilotons;
   define country  / group width=14 format=$cntry.;
   define type     / group 'Type of Grain';
   define kilotons / format=comma12.;
   footnote 'Measurements are in metric tons.';
run;
/* PROC TABULATE */
proc tabulate data=grain_production format=comma12.;
   class year country type;
   var kilotons;
   table year, 
         country*type, 
         kilotons*sum=' ' / box=_page_ misstext='No data';
   format country $cntry.;
   footnote 'Measurements are in metric tons.';
run;
/* PROC SGPLOT */
proc sgplot data=sashelp.class;
  scatter x=height y=weight / group=sex;
run;

proc sgplot data=contest;
histogram num_books/showbins scale=count;
density num_books/type=normal ;
title2 'Reading Contest';
run;

proc sgplot data=bikerace;
  HBOX num_laps/category=division;
  title2 "Results by Division";
run;

proc gchart data=sashelp.cars;
  pie type/discrete value=inside
           percent=outside slice=inside;
run;
/* PROC UNIVRIATE */
proc univariate data=Trans noprint;
   histogram Thick/normal;
   probplot Thick;
run;
/* PROC TTEST */
data read;
   input score count @@;
   datalines;
40 2   47 2   52 2   26 1   19 2
25 2   35 4   39 1   26 1   48 1
14 2   22 1   42 1   34 2   33 2
18 1   15 1   29 1   41 2   44 1
51 1   43 1   27 2   46 2   28 1
49 1   31 1   28 1   54 1   45 1
;
run;
ods graphics on;

proc ttest data=read h0=30;
   var score;
   freq count;
run;

ods graphics off;
/* PROC LOGISTIC */
/*
libname tt 'C:\SAS Course\SAS Original\Other Data';
proc contents data=tt.logit; run;

proc logistic data=tt.logit descending;
  model admit = gre topnotch gpa; 
;
run;

proc logistic data=tt.logit descending;
  model admit = gre gpa; 
;
run;

/* PROC REG */
/*
data fitness; 
      input Age Weight Oxygen RunTime RestPulse RunPulse MaxPulse @@; 
      datalines; 
   44 89.47 44.609 11.37 62 178 182   40 75.07 45.313 10.07 62 185 185 
   44 85.84 54.297  8.65 45 156 168   42 68.15 59.571  8.17 40 166 172 
   38 89.02 49.874  9.22 55 178 180   47 77.45 44.811 11.63 58 176 176 
   40 75.98 45.681 11.95 70 176 180   43 81.19 49.091 10.85 64 162 170 
   44 81.42 39.442 13.08 63 174 176   38 81.87 60.055  8.63 48 170 186 
   44 73.03 50.541 10.13 45 168 168   45 87.66 37.388 14.03 56 186 192 
   45 66.45 44.754 11.12 51 176 176   47 79.15 47.273 10.60 47 162 164 
   54 83.12 51.855 10.33 50 166 170   49 81.42 49.156  8.95 44 180 185 
   51 69.63 40.836 10.95 57 168 172   51 77.91 46.672 10.00 48 162 168 
   48 91.63 46.774 10.25 48 162 164   49 73.37 50.388 10.08 67 168 168 
   57 73.37 39.407 12.63 58 174 176   54 79.38 46.080 11.17 62 156 165 
   52 76.32 45.441  9.63 48 164 166   50 70.87 54.625  8.92 48 146 155 
   51 67.25 45.118 11.08 48 172 172   54 91.63 39.203 12.88 44 168 172 
   51 73.71 45.790 10.47 59 186 188   57 59.08 50.545  9.93 49 148 155 
   49 76.32 48.673  9.40 56 186 188   48 61.24 47.920 11.50 52 170 176 
   52 82.78 47.467 10.50 53 170 172 
   ; 
   proc reg data=fitness; 
      model Oxygen=Age Weight RunTime RunPulse RestPulse MaxPulse ;
   run;

*/


/* PROC SQL */

data one;
  input x y;
  cards;
  1 5
  2 10
  3 20
  4 40
  5 80
  ;
run;

data two;
  input x z;
  cards;
  2 100
  6 200
  8 300
  9 500
  ;
run;

/* Inner Joins  */
proc sql;
  create table three as
  select *
  from one a, two b
  where a.x=b.x;
quit;
proc print data=three; run;

/* Left Outer Joins   */
proc sql;
  create table three as
  select *
  from one left join two
  on one.x=two.x;
quit;

/* Right Outer Joins   */
proc sql;
  create table three as
  select *
  from one right join two
  on one.x=two.x;
quit;
/* Full Outer Joins  */
proc sql;
  create table three as
  select *
  from one, two;
quit;


data country_population;
  input name $ Population area ;
  cards;

Afghanistan 17070323 251825    
Albania 3407400 11100   
Algeria 28171132 919595    
Andorra 64634 200   
Angola 9901050 481300    
Antigua 65644 171   
Argentina 34248705 1073518    
Armenia 3556864 11500   
Australia 18255944 2966200     
Austria 8033746 32400  
;
run;

proc sql ;   
   title 'Densities of Countries';
   create table densities as 
      select Name 'Country' format $15.,
             Population format=comma10.0,
             Area as SquareMiles,
             Population/Area format=6.2 as Density
      from country_population;
quit;


proc sql;
  select enginesize,
    case
	when   enginesize<=2   then "LOW"
	when 2<enginesize<=3   then "INTERMEDIATE"
	else                        "HIGH"
	end "HORSE_POWER"
  from sashelp.cars
  ;
quit;
/* PROC RANK */

libname tt "\\file1\LabShare\DSA 04-Feb-2019\SAS\data";
proc sort data=tt.wireless(where=(province not like '$%')) out=wireless nodupkey;
  by acctno;
run;
data phase2;
  set wireless;
  if province ^='  ' and sales ^=.;
run; 
proc sort data=phase2;
  by province descending sales;
run;
PROC RANK DATA =phase2(KEEP= province sales) descending
               GROUPS = 10
               OUT = group_10     ;
			by province           ;
            RANKS rank            ;
            VAR sales             ;
RUN  ; 

/* PROC TRANSPOSE */
data quiz;
  input stid : $5. gender : $1. quiz score @@;
datalines;
CA001 M 1 86 CA001 M 2 75 CA001 M 3 83 CA001 M 4 90 CA001 M 5 68 CA002 M 1 72
CA002 M 4 79 CA002 M 5 93 CA002 M 2 92 CA002 M 3 68 CA003 F 1 95 CA003 F 2 87
CA003 F 3 89 CA003 F 4 100 CA003 F 5 90 CA004 M 1 96 CA004 M 2 95 CA004 M 3 78
CA004 M 4 78 CA004 M 5 91 CA005 F 1 83 CA005 F 2 86 CA005 F 2 96 CA005 F 4 80
CA005 F 5 65
;
RUN;
proc print data=quiz; run;

proc sort data=quiz;
  by stid gender;
run;
proc transpose data=quiz out=quiz_t(drop=_name_) prefix=score;
  by stid gender;
  id quiz;
  var score;
run;
proc print data=quiz_t noobs;
run;

/* PART II: MACRO */
%let var1=Metro College;
%put &var1;

%put &SYSTIME ;
%put &SYSDATE9;
%put &SYSDATE;
%put &SYSDAY;


data test;
  input student $ score;
cards;
001 95
002 85
003 75
;
run;

%macro pmean(da= , vname= );
proc means data=&da;
  var &vname;
run;
%mend;

%pmean(da=test, vname=score);


libname tt "\\file1\LabShare\DSA 04-Feb-2019\SAS\data";
%macro doit(out=, f1=, f2=, keyv=);
proc sort data=tt.&f1 out=&fl;
  by &keyv;
proc sort data=tt.&f2 out=&f2;
  by &keyv;
data &out;
  merge &f1(in=a) &f2(in=b);
  by &keyv;
  if a and b;
run;
%mend;
%doit(out=f3, f1=staff2, f2=payroll2, keyv=idnum);

libname tt "\\file1\LabShare\DSA 04-Feb-2019\SAS\data";
%macro psql(f1=, f2=, lb= );
  proc sql;
    select b.idnum, a.fname, a.lname
	from &lb..&f1 a,
	     &lb..&f2 b
	where a.idnum=b.idnum
	;
  quit;
%mend psql;
%psql(f1=staff2, f2=payroll2, lb=tt);


DATA _NULL_;
%LET X=XYZ.ABC/XYY;
%LET WORD=%SCAN(&X, 3);
%LET PART=%SCAN(&X, 1, Z);
%PUT WORD IS &WORD AND PART IS &PART;
RUN;


DATA _NULL_;
%LET X=fname.mname/lname;
%LET WORD=%SCAN(&X, 3);
%LET PART=%SCAN(&X, 1, l);
%PUT WORD IS &WORD AND PART IS &PART;
RUN;


%let dsn=metroc;
%let string=%nrstr($stuff$&dsn$&morestuff);

%let wscan=%scan(&string, 2, $);
%put &wscan ;

%let wqscan=%qscan(&string, 2, $);
%put &wqscan;

%let sub=%substr(&string, 8, 5);
%put &sub;

%let qsub=%qsubstr(&string, 8, 5);
%put &qsub;


%let dsn=clinics;
%let string=%nrstr(*stuff*&dsn*&morestuff);

%let wscan=%scan(&string, 2, *);
%put &wscan ;

%let wqscan=%qscan(&string, 2, *);
%put &wqscan;

%let sub=%substr(&string, 8, 5);
%put &sub;

%let qsub=%qsubstr(&string, 8, 5);
%put &qsub;


%macro a;
   aaaaaa
%mend a;


%macro b;
   bbbbbb
%mend b;
%macro c;
   cccccc
%mend c;


%let x=%nrstr(%a*%b*%c);
%put X: &x;

%put The third word in X, with SCAN: %scan(&x,3,*);
%put The third word in X, with QSCAN: %qscan(&x,3,*);


%macro myprnit(var1,var2);
   PROC PRINT data = &var1..&var2;
   Run;
%mend myprnit;
 
%myprnit (sashelp,cars);

%let x=5;
%let y=&x+1;
%let z=%eval(&x +1);
%put &x &y &z;

%let p=%str(proc print data=dsn; run;);
%put &p;


data _null_;
  x=5;
  call symput('five',x);
run;
 %put *&FIVE*;
 %LET FIVE=*%CMPRES(&FIVE)*;
 %PUT &FIVE;

%INCLUDE "C:\test\MACRO_SASPGM.SAS";

%SASPGM(sashelp.class);

/* PART III FUNCTION */
/* DSD */
data b;
 infile datalines dsd delimiter = ","; * dsd stands for delimiter separated data;
 input name $ x y z;
 datalines;
 "MM", 2.1,   2.2, 5.91
 F, 6.85, 3.44, 3.14
  , 7.56, 6.57, 5.77
 ;
 run;

 proc print data = b;
 run;

 Data c;
 infile datalines; 
 input date : ddmmyy10.
       fname : $20.
	   sname : $20.
       x;

datalines;
 19.2.2001 Adam Jones 102.8
 12.12.2004 Joan Jones 110.8
 ;
 run;

 proc sql;
  select id, coalesce (price,1) as n_price, coalesce (tax, 1) as n_tax
  from example;
quit;


proc sql;
  select id, gender, coalesce(gender, "F") as n_gender
  from example1;
quit;


data _NULL_;
  set flowersales;
  if _N_=1 then call symput("select", customerid);
  else stop;
run;
%put &select;

DATA _NULL_;
%LET X=LONG TALL SALLY;
%LET Y=%INDEX(&X, TALL);
%PUT TALL CAN BE FOUND AT POSITION &Y;
RUN;


DATA _NULL_;
%LET X=XYZ.ABC/XYY;
%LET WORD=%SCAN(&X, 3);
%LET PART=%SCAN(&X, 1, Z);
%PUT WORD IS &WORD AND PART IS &PART;
RUN;


data temp;
sample_str = "Pin Code 411014";
all_str = SUBSTR(sample_str,1);
wrong_lngth = SUBSTR(sample_str,5,100);
wrong_strt = SUBSTR(sample_str,100,2);
run;


 data vitals;;   
input pat test $ visit1 visit2 visit3 visit4; 
cards; 
16 SBP 112 118 120 114 
35 SBP 120 155 140 130 
93 SBP 110 115 110 115 
; 
run; 

 data sbp;  
set vitals;  
array vitals[4] visit1-visit4;  
  do I=1 to 4;   
     result=vitals(i);   
     output;  
  end;  
keep pat test result; 
run; 
proc print data=sbp;
run;

/* PART IV: DATA STEP */

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

proc sort data=Patients;
   by PatientID Date;
run;
 
data weightLoss;
   set Patients;
   BY PatientID;
   retain startDate startWeight;                 /* RETAIN the starting values */
   if FIRST.PatientID then do;
      startDate = Date; startWeight = Weight;    /* remember the initial values */
   end;
   if LAST.PatientID then do;
      endDate = Date; endWeight = Weight;
      elapsedDays = intck('day', startDate, endDate); /* elapsed time (in days) */
      weightLoss = startWeight - endWeight;           /* weight loss */
      AvgWeightLoss = weightLoss / elapsedDays;       /* average weight loss per day */
      output;                                         /* output only the last record in each group */
   end;
run;
 
proc print noobs; 
   var PatientID elapsedDays startWeight endWeight weightLoss AvgWeightLoss;
run;
