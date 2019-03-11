/*_N_ refering to the observation ID and is the system index regardless of you run or not*/
/* macro variables can be seen in the log window*/
/*%let var = .. can be replaced by call symput( , )*/
/*when we know the value we can use %let method; othewise, it is the second approach
index talks about position.*/
/* %scan(sentence, 1, z) stops at the z
if we do not put delimiter the computer automatically selects the "." or "/" as the delimiters
but after they have been assigned as the delimiter then it is counted as the parted */
/*nrstr() function alloes the existance of the * and & in the string*/
/*qscan is similar to the scan except it does not allow the & to effect; does not let & to be the 
macro operator */
/*%scan if you meet the & then will change the macro valier but qscan does not change the & */ 
/*substr() start to pick from the start for the length been shown and if you use the qsubstr() 
the same philosophy, meaning thet you are not operating the & */


*practice;
data _NULL_;
%let X=fatemeh.m/kieia;
%let word=%scan(&X,3);
%let part=%scan(&X, 1,k); /*k is delimiter*/
%put word is &word and part is &part;
run;

%let dsn=metro;
%let string=%nrstr(*stuff*&dsn*&morestuff);

%let wscan=%scan(&string, 2,*); 
%put &wscan;

%let wqscan=%qscan(&string, 2, *);
%put &wqscan;

%let sub = %substr(&string, 8, 5);
%put &sub;

%let qsub = %qsubstr(&string, 8, 5);
%put &qsub;

/*****/
%let mname=mansour;
%let string=%nrstr(fatemeh.&mname.kiaie);

%let wscan=%scan(&string, 2, .);
%put &wscan;

%let wqscan=%qscan(&string, 2, .);
%put &wqscan;

%let sub = %substr(&string, 8, 5);
%put &sub;

%let qsub = %qsubstr(&string, 8, 5);
%put &qsub;

/* nrstr()  says do not use % as the macro operator adn allows you to use special character 
moreover the Qcan does not operate the % functions*/
%macro b;
bbbbbb
%mend b;

%macro c;
cccccc
%mend c;

%let x =%nrstr(%a*%b*%c);
%put X: &x;

%put the third word in X, with SCAN: %scan(&x, 3, *);
%put the third word in X, with QSCAN: %qscan(&x, 3, *);

/* verify gives the position of difference*/
%let code = 2000SUGI25;
%let part = %substr(&code, %verify(&code, 1234567890));
%put Z= &part;


data test1;
x= 'abc';
y= 'abcdef';
z=verify(y,x);

x1='abcdef';
y1='abcdef';
z1=verify(y1,x1);
run;

proc print data=test1;
var z z1;
run;

/*including macros programs and invoking*/
%include "C:"
%saspgm(flowerser);

/*creating your own macro procs libraries*/
%include "C:\Users\mfatemeh\Desktop\my_macro.sas";
%pmeans_1(sashelp.cars, Enginesize, Horsepower);

/***saved file in my_macro***/

%macro pmeans_1(dsn, var1, var2);
proc means data = &dsn;
var &var1 &var2;
run;
%mend;
