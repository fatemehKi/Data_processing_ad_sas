/*Output delivery system*/

/*
ods csv file = file physical location
your proc
rnd
ods csv close
*/

/*to deliver and open html
ods html
path= physical location without the fike name
file = 'filename.html'
style=EGDefault;

proc print data=fimename2;
ods html close;
*/

ods html;
path = "C:\Users\mfatemeh\Desktop\test";
file = 'mine4.html';
style = EGDefault;

proc print data=mine; /*an existing data*/
run;
ods html close;

/*we also have pdf and rtf (word format) with ods 
except for html we need to give path*/

/*--- practice---*/

data golf;
input coursename : $9. @10 num_holes par yeardage greenfees;
datalines;
Ka Plan    18 73 7263 125.00
Puka       18 72 6945 55.00
;
run;
/*below codes create a golf1.csv file for us and does let us to have 
it in the mentioned physical location*/
ods csv file= 'C:\Users\mfatemeh\Desktop\test\golf1.csv'; /*regardless of the existance of that csv file*/
proc print data=golf noobs; /*an existing data*/
run;
ods csv close; 

/*creating a pdf file*/
ods pdf file = 'C:\Users\mfatemeh\Desktop\test\golf1.pdf';
proc print data=golf noobs; /*an existing data*/
run;
ods pdf close;

/*meaning we can have multiple format files it makes it easy to understand which 
is open.. keep them open*/
ods listing;

/*creating RTF file*/
ods rtf file = 'C:\Users\mfatemeh\Desktop\test\golf1.rtf';
proc print data=golf noobs; /*an existing data*/
run;
ods rtf close;

/*creating the HTML file*/
ods html;
path = "C:\Users\mfatemeh\Desktop\test";
file = 'golf1.html';
style = EGDefault;
proc print data=golf; /*an existing data*/
run;
ods html close;

/*therefore, we have a bit different format in html*/
 
