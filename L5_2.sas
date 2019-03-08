%let var1=Metro College;
%put &var1;


%put &SYSTIME ;
%put &SYSDATE9;
%put &SYSDATE;
%put &SYSDAY;

data tt1;
  input id fname $ lname $;
cards;
1 David Lee
2 Mary  Ma
;
run;

%let dtt=test;
%let var1=Metro College;

%macro prt(new=);
proc print data=&new noobs;
  title "&var1";
run;
%mend;

%prt(new=test);
%prt(new=tt1);


%macro pmean(da= , vname= );
proc means data=&da;
  var &vname;
run;
%mend;

%pmean(da=test, vname=score);


data test;
  input student $ score;
cards;
001 95
002 85
003 75
;
run;
%put var1 = &var1;

proc print data=test noobs;
  title "&var1";
run;
title ' ';

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

%let ftype=Ginger;

data t1;
  set flowersales;
  where variety="&ftype";
run;
 
proc print data=t1;
  format SaleDate mmddyy10. saleamount dollar8.2;

  title "Flower Type is &ftype";
run;
title ' ';

data one;
  input id s1 s2 s3;
  cards;
  1 65 75 85
  2 95 85 55
  3 60 59 93
  ;
run;
%let avg_score=a_score;
%let ttitle=Metro College Student Score;

data two;
  set one;
  &avg_score=round(mean(of s1 - s3), 0.1);
run;

proc print data=two;
  title "&ttitle";
run;


%let region=West;
%let myname=Sam;

data test;
  office="NorthAmerican&region";
  office1="&region.Cost";
run;
%prt(new=test);


proc print data=test; run;

data &myname.sale;
  set test;
run;

data &region&myname.sale;
  set test;
run;


%let sumvar=Quantity;
%let sasdate=20181212;

ODS RTF FILE="C:\test\FLOWERSALE_&SASDATE..RTF";
proc means data=flowersales sum min max maxdec=0;
  var sales&sumvar;
  class variety;
  title "Summary of Sales &sumvar by Variety";
run;
ODS RTF CLOSE;
ods listing;

%macro doit(data);
  proc print data=&data;
  title "&data";
  run;
%mend doit;
%doit(t1);

%macro doit(data, varname);
  proc print data=&data;
    var &varname;
  title "&data";
  run;
%mend;
%doit(t1,CustomerID Variety );

%MACRO sample(data, varname, tf);
 
PROC SORT DATA = &data;
BY DESCENDING &varname;
RUN;
PROC PRINT DATA = &data (OBS = 5);
TITLE "&tf";
RUN;

FILENAME MYFILE 'C:\test\FLOWERS.TXT';
DATA _NULL_;
set flowersales;
FILE MYFILE;
PUT CustomerID $4. @6 SaleDate MMDDYY10. @17 Variety $9. salesQuantity;
RUN;
%MEND sample;

%sample(one, s3, Student Score);

%let sumvar=Quantity;
%let clasname=variety;

%MACRO DAILYREPORT;
%if &SYSDAY=Thursday %then 
   %do;
   %put &SYSDAY;
   proc print data=FLOWERSALES;
     FORMAT SaleDate WORDDATE18. saleamount dollar8.2;
	 title "Wednesday Report : Current Flower Sales";
   run;
   %end;
 %else %if &SYSDAY=Friday %then 
   %do;
   proc means data=FLOWERSALES mean min max;
     class &clasname;
	 var sales&sumvar;;
	 title "Thursday Report : Current Flower Sales";
   run;
   %end;
%mend;
%DAILYREPORT;


%let current=201801;
%put &current;
/* %global : Creates macro variables that are available duringthe execution of an entire SAS session */
       
%macro dataset(date, i);
	%global curr_&i;
	data _null_;
		year=(int(&date/100)*100);
		call symput('year', year);
	run;

	%put year &year;

	data _null_;
		month=&date - &year;
		call symput("month", month);
	run;

	%put month &month;

	data _null_;
		curr_&i=&date-1;
		%if &month=1 %then
			%do;
				curr_&i=&date-89;
			%end;
		call symput("curr_&i", TRIM(LEFT(curr_&i)));
	run;
%mend dataset;

%dataset(&current,1);

%dataset(&curr_1, 2);
%dataset(&curr_2, 3);


%put current &current;
%put curr_1 &curr_1;
%put curr_2 &curr_2;


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
