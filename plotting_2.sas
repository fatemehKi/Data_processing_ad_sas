/*graphic is under ODS*/
proc sort data=sashelp.class out=c;
by sex;
run;
/*defining the structure of graph*/
data anno1;
retain x1 20 y1 85 function 'Text' dataspace 'GraphicPercent' width 100;
label= 'stu'; output;
run;

proc sgplot data=c sganno=anno1 tmplout ='tmp';
scatter y= weight x=height;
by sex;
run; 

/*bar chart*/
ods graphic on;
goptions RESET=ALL; 
proc sgplot data=c;
hbar age;
label favorite='flavor of choco';
title 'bar chart for flavor of choco';
run;

/*historical variables needed to be continues*/
proc sgplot data=sashelp.class;
histogram weight/showbins scale=count; /*show bins is responsible to show the bars*/
density weight/type=normal;
title2 'Weight';
run;

proc sgplot data=sashelp.class;
histogram height/showbins scale=count;
density height/type=normal;
title2 'height';
run;

proc sgplot data=sashelp.class;
histogram age/showbins scale=count;
density age/type=normal;
title2 'age';
run;

/*easy scatter type*/
proc gplot data=sashelp.class;
plot height*weight;
run;

/*pie chart*/
proc gchart data=sashelp.cars;
pie type/discrete value =inside
percent=inside slice=inside;
run;
