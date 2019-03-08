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
