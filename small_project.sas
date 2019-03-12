libname pr "C:\Users\mfatemeh\Desktop\in share\adv\project";

data cleaned;
set pr.wireless;
where province not like '%$%';
run;

/*we need out for the sort with the by*/
proc sort data=cleaned(obs=500) out=s_clean;
by ACCTNO;
run;

/*we don't need out for freq but we need the table*/
proc freq data=s_clean;
table ACCTNO;
run;

/*make sure the output doesn't have = infront; we use output not out*/
data active deactive;
set s_clean;
if Deactdt =. then output active;
else               output deactive;
run;

/****in the proc means the output comes in a total different way.*/
proc means data=active MIN MAX;
var actdt;
output out=min_max_a;
run;

proc means data=deactive MIN MAX;
var deactdt;
output out=max_min_d;
run;


/*********Q2*/
%macro q2_2(da, var);
proc freq data=&da;
table &var/missing list;
title "Data &da Distribution by &var";
run;
%mend

%q2_2(active, province);


/*proc format DOES NOT have data= at the beginning, it is a general format*/
proc format;
value Agefm Low-<21  = '<= 20  '
            21 -<41  = '21 - 40'
		    41 -<61  = '41 - 60'
		    61 -high = '61+    '
;
value salefm
            Low -<101='<=100  '
	        101 -<501='101-500'
	        501 -<801='501-800'
	        801 -high='801 +  '
;
value $profm
            'BC','SK','AB'     ='West Provinces   '
		    'PE','NS','NB','NL'='Ocean Provinces  '
		    'MT','QC','ON'     ='Central Provinces'
		    other              ='Unknown          '
;
run;


ods csv file='C:\Users\mfatemeh\Desktop\in share\adv\project\pro.csv';
proc print data = s_clean;
format Age Agefm. Province $profm. Sales salefm.;
run;
ods csv close;


proc tabulate data=s_clean;
class  Age Province;
var sales;
format  Age Agefm. Province $profm. Sales salefm.;
table province*all, age*N ;
run;

data tenur;
set S_clean (keep=ACCTNO actdt deactdt);
if Deactdt =. then tenur= today()- Actdt;
else               tenur = Deactdt- Actdt;
run;
