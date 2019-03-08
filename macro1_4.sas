/*--we can use macro for a variable and also for the data set and also for a 
function (program)
make sure to use ampersand always
*/
data test;
input id score;
cards;
1 20
3 50
;
run;

proc print data =test;
run;

%macro pmean(da, vname);
proc means data=&da;
var &vname;
run;
%mend;

%pmean(test, score);

libname tt 'c:\test';
%let dname=firstfile;
data tt.&dname;

/*create macro variables
left side is the macro variable and right side is the macro value*/
%let my_name=Fatemeh Kiaie;
%put full_name=&my_name;

/*create macro program*/
/*proc print*/
libname staff_ 'C:\Users\mfatemeh\Desktop\in share\adv';

%macro mprint(da, var);
proc print data=staff_.&da;
var &var;
run;
%mend

%mprint(Staff2, IDNUM);
%mprint(Payroll2, IDNUM);
%mprint(Staff2, IDNUM LNAME);
%mprint(Payroll2, IDNUM SEX);

/*data steps*/
%macro mdata2(da1, var1 );
proc sort data= staff_.&da1 out = new_1;
by &var1;
run;
proc print data= new_1;
run;
%mend

%macro mdata(da1, da2, var1);
proc sort data= staff_.&da1 out=new_1;
by &var1;
run;
proc sort data= staff_.&da2 out=new_2;
by &var1;
run;
data new_3;
merge new_1 new_2;
by &var1;
run;
%mend;

%mdata(Staff2, Payroll2, IDNUM);

/*Zho's*/
%let var=Fname;
%let var2=Lname;
proc print data=staff_.Staff2;
var &var &var2;
run;

libname tt 'C:\Users\mfatemeh\Desktop\in share\adv';
%macro doit(out=, f1=, f2=, keyv=);
proc sort data=tt.&f1 out=&f1;
by &keyv;
proc sort data=tt.&f2 out=&f2;
by keyv;
data &out;
merge &f1(in=a) &f2(in=b);
by &keyv;
if a and b;
run;
%mend;

%doit(out=f3, f1=staff2, f2=payroll2, keyv=idnum);

libname tt 'C:\Users\mfatemeh\Desktop\in share\adv';
%macro psql(f1, f2, lb);
proc sql;
select b.idnum, a.fname, a.lname
from &lb..&f1 a, &lb..&f2 b
where a.idnum=b.idnum;
run;
%mend psql;
%psql(staff2, payroll2, tt);
