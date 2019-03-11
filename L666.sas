
data flowersales;
input CustomerID $ SaleDate : mmddyy10. Variety $ salesQuantity saleamount;

datalines;
240W 02-07-2008 Ginger 120 960
240W 02-07-2008 Protea 180 1710
356W 02-08-2008 Heliconia 60 720
356W 02-08-2008 Anthurium 300 1050
188R 02-11-2008 Ginger 24 192
188R 02-11-2008 Anthurium 24 96
240W 02-12-2008 Heliconia 48 600
240W 02-12-2008 Protea 48 456
356W 02-12-2008 Ginger 240 1980
;
run;

proc sort data=flowersales;
  by descending saleamount;
run;

data flower;
  set flowersales;
run;

data _NULL_;
  set flowersales;
  if _N_=1 then call symput("select", customerid);
  else stop;
run;
%put &select;

proc print data=flowersales;
  where customerid="&select";
   format SaleDate mmddyy10. saleamount dollar8.2;
  title "Customer &select for the single largest order";
run;

DATA _NULL_;
%LET X=LONG TALL SALLY;
%LET Y=%INDEX(&X, TALL);
%PUT TALL CAN BE FOUND AT POSITION &Y;
RUN;

%macro look(dsn, obs);
  %if %length(&dsn) gt 8 %then 
      %put Name is too long - &dsn;
  %else 
    %do;
      proc contents data=&dsn;
	  title "data set &dsn";
	  run;

	  proc print data=&dsn (obs=&obs);
	    title "First &obs observations";
	  run;
	%end;
%mend;
%look(FLOWERSALES, 5);

%look(flower, 5);


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


/* %NRSTR Function

Masks special characters, including & and %,and operators in constant text during macro compilation. 

%SCAN and %QSCAN Functions

Search for a word that is specified by its positionin a string. 
*/
%let x=%nrstr(%a*%b*%c);
%put X: &x;

%put The third word in X, with SCAN: %scan(&x,3,*);
%put The third word in X, with QSCAN: %qscan(&x,3,*);

data temp;
sample_str = "Pin Code 411014";
all_str = SUBSTR(sample_str,1);
wrong_lngth = SUBSTR(sample_str,5,100);
wrong_strt = SUBSTR(sample_str,100,2);
run;
 
proc print data = temp;
run;

%let hg=Name;
data gg_;
set sashelp.class; 
gh=%substr(&hg,1,4);
run;
proc print data=gg_;
run;

data gg_;
set sashelp.class; 
gh=substr(name,1,4);
run;
proc print data=gg_;
run;

%let a=one;
%let b=two;
%let c=%nrstr(&a &b);
%put C: &c;
%put With SUBSTR: %substr(&c,1,2);
%put With QSUBSTR: %qsubstr(&c,1,2);


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

data _NULL_;
  today=put(date(), worddate18.);
  call symput('dtnull',today);
run;
%put &dtnull;
/*
title "Using SYSFUNC %SYSFUNC(LEFT(%QSYSFUNC(DATE(), WORDDATE18.)))";

%VERIFY returns the position of the first character in source 

VERIFY Function Returns the position of the first character that is unique to an expression. 
*/

%let code=2000SUGI25;
%let part=%substr(&code, %verify(&code,1234560));
%put &part;


%let x=abc;
%let y=abcdef;
%let z=%verify(&y,&x);
%put Z=&z;
 
%let x=abcdef;
%let y=abcdef;
%let z=%verify(&y,&x);
%put z=&z;

data test1;
x='abc';
y='abcdef';
z=verify(y,x);

x1='abcdef';
y1='abcdef';
z1=verify(y1,x1);
run;

proc print data=test1;
  var z z1;
run;

 
data _null_;
  x=5;
  call symput('five',x);
run;
 %put *&FIVE*;
 %LET FIVE=*%CMPRES(&FIVE)*;
 %PUT &FIVE;

OPTIONS MPRINT SYMBOLGEN MLOGIC;

%INCLUDE "C:\test\MACRO_SASPGM.SAS";

%SASPGM(sashelp.class);

title ' ';


%INCLUDE "C:\test\PMEANS.SAS";

%pmeans(sashelp.class,WEIGHT, HEIGHT);



