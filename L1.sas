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
 
 data c;
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

 proc print data = c;
  format date mmddyy10. ;
 run;
 
 data _NULL_;
  file 'C:\SAS Course\SAS Advanced_Final\data\example1_3.csv' ;
    set c;
  put date : ddmmyy10.
      fname : $20.
	  sname : $20.
	  x;
run;

 data c1;
 infile 'C:\SAS Course\SAS Advanced_Final\data\example1_3.csv' ;
 input date : ddmmyy10.
       fname : $20.
	   sname : $20.
       x;
 run;
 
 proc print data = c1;
  format date mmddyy10. ;
 run;
 


data golf;
  input coursename : $9. 
        @10 num_holes par yeardage greenfees;
datalines;
Ka Plan  18 73 7263 125.00
Puka     18 72 6945 55.00
San      18 72 6469 35.00
Silver   18 71 .    57.00
Waie     18 72 6330 25
Grand    18 72 6122 200.00
;
run;
proc print data=golf;
run;

 data _NULL_;
  file 'C:\SAS Course\SAS Advanced_Final\data\golf1.dat' ;
    set golf;
  put coursename 'Golf Course' 
      @32  greenfees dollar7.2
	  @40 'parmm' Par;
run;

ods csv file='C:\SAS Course\SAS Advanced_Final\data\golf1.csv' ;
proc print data=golf;
run;
ods csv close;

ODS HTML 
   PATH = 'C:\SAS Course\SAS Advanced_Final\data\'
   FILE = 'golf1.html'
   STYLE = EGDefault;

proc print data=golf;
run;
ods html close;


data marine;
  input name $ family $ length @@;
datalines;
beluga whale 15 dwarf shark 0.5 basking shark 30 humpback whale 50
whale  shark 40 blue whale  100 killer whale  30 mako shark     12
;
run;
proc print data=marine; run;

/* STYLE: Specify a style template to use in writing outputfiles 
FRAME: Specify the file that integrates the table of contents,the page contents, and the body file 
BODY: Open a markup family destination and specify thefile that contains the primary output that is created by the ODS statement 
CONTENTS: Open the HTML destination and specify the filethat contains a table of contents for the output 
*/
ODS HTML STYLE=D3D FILE='marine.html'
                   /*FRAME='marinefRAME.html'
				   CONTENTS='marineTOC.html'*/;
ODS NOPROCTITLE;
PROC MEANS DATA=marine mean min max;
  class family;
  title 'Whales and Sharks';
run;;
proc print data=marine;
run;
ODS HTML CLOSE;

ODS RTF FILE='C:\SAS Course\SAS Advanced_Final\data\MARINE.RTF';
/*BODYTITLE STARTPAGE=NO;
ODS NOPROCTITLE;*/

proc print data=marine;
run;
ODS RTF CLOSE;

ODS PDF FILE='C:\SAS Course\SAS Advanced_Final\data\MARINE.PDF';
/*BODYTITLE STARTPAGE=NO;
ODS NOPROCTITLE;*/

proc print data=marine;
run;
ODS PDF CLOSE;

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

 
proc sort data=grain_production;
   by year country type;
run;
 
proc format;
   value $cntry 'BRZ'='Brazil'
                'CHN'='China'
                'IND'='India'
                'INS'='Indonesia'
                'USA'='United States';
run;
 
ods listing close;
 
ods html file='grain-body.htm'
     contents='grain-contents.htm'
        frame='grain-frame.htm'
         page='grain-page.htm'
         /*base='http://www.yourcompany.com/local-address/'*/
 
     newfile=page;
 
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
 
options byline;
title2;
 
proc tabulate data=grain_production format=comma12.;
   class year country type;
   var kilotons;
   table year, 
         country*type, 
         kilotons*sum=' ' / box=_page_ misstext='No data';
   format country $cntry.;
   footnote 'Measurements are in metric tons.';
run;
 
ods html close;
ods listing;

data energy;
   length State $2;
   input Region Division state $ Type Expenditures;
   datalines;
1 1 ME 1 708
1 1 ME 2 379
4 4 HI 1 273
4 4 HI 2 298
;
 
proc format;
   value regfmt 1='Northeast'
                2='South'
                3='Midwest'
                4='West';
   value divfmt 1='New England'
                2='Middle Atlantic'
                3='Mountain'
                4='Pacific';
   value usetype 1='Residential Customers'
                 2='Business Customers';
run;
 
options nodate pageno=1 linesize=80 pagesize=60;
 
proc tabulate data=energy format=dollar12.;
 
   class region division type;
   
 
   var expenditures;
 
    table region*division,
          type*expenditures
 
          / rts=50;
 
   format region regfmt. division divfmt. type usetype.;
 
   title 'Energy Expenditures for Each Region';
   title2 '(millions of dollars)';
run;

Data test;
Input T1 T2 T3 T4 T5 Age BU;
Cards;
1 5 2 3 4 3 3
4 5 2 1 2 1 3
3 4 4 3 2 3 2
4 3 2 5 3 3 3
1 2 4 2 1 2 2
;
Run;
Proc tabulate data = test;
Var T1;                                                                                           
Table T1;           
Run;
Proc tabulate data = test;
Var T1;
Table T1 * N;
Run;
Proc tabulate data = test;
Var T1;
Table T1 * (N SUM);
Run;
Proc Tabulate Data = test;
Class Age;
Var T1;
Table Age, T1 * (N COLPCTN);
Run;
Proc Tabulate Data = test;
Class Age;
Var T1;
Table T1, Age * (N ROWPCTN);
Run;
Proc Tabulate Data = test;
Class Age;
Var T1;
Table Age, T1 = "Group I" * (N="Count" COLPCTN="%");
Run;
Proc Tabulate Data = test;
Class Age;
Var T1;                                                                               
Keylabel N="Count" COLPCTN="%";
Table Age, T1 = "Group I" * (N COLPCTN); 
Run; 
Proc Tabulate Data = test;
Class Age;
Var T1;
Table Age=" ", T1 = "Group I" * (N="Count" COLPCTN="%") / box="Age";
Run;
Proc Tabulate Data = test;
Class Age;
Var T1;
Table Age ALL = "Grand Total" , T1 = "Group I" * (N="Count" COLPCTN="%");
Run;
Proc tabulate data = test;
Class Age BU;
Var T1;
Table T1="Group I",(Age * BU="Business Unit") * (N="Count" ROWPCTN="%");
Run;
Proc tabulate data = test;
Class Age BU;
Var T1;
Table T1="Group I",(Age=" " * BU="Business Unit") * (N="Count" ROWPCTN="%");
Run;
Proc tabulate data = test;
Class Age BU;
Var T1;
Table T1="Group I",(Age=" " * BU="Business Unit") * (N="Count" ROWPCTN="%");
Run;
Proc format;                                                                                                                           
value agefmt                                                                                                                           
1 = 'Under 18'                                                                                                                       
2 = '18 - 25'                                                                                                                         
3 = 'Over 25';                                                                                                                       
Run;                                                                                                                                   
                                                                                                                                      
Proc format;                                                                                                                           
value bufmt                                                                                                                           
1 = 'Analytics'                                                                                                                       
2 = 'Technology'                                                                                                                     
3 = 'Others';                                                                                                                         
Run;
                                                                                  
Proc tabulate data = test;
Format Age agefmt. BU bufmt.;
Class Age BU;
Var T1;                                                                                                                     
Keylabel N="Count" ROWPCTN="%";
Table T1="Group I",(Age * BU="Business Unit") * (N ROWPCTN * F=6.0); 
Run; 
Data test;
length BU $18.;
Input Location$ BU$ Gender$ Income;
Cards;
Delhi Analytics Male 5000
Mumbai Tech Female 45000
Delhi Analytics Male 37000
Chennai Tech Male 33000
Delhi Tech Male 5000
Chennai Analytics Male 15000
Mumbai Analytics Female 440000
Delhi Analytics Female 5000
Mumbai Tech Male 45000
Delhi Analytics Female 37000
Chennai Tech Female 33000
Delhi Tech Female 5000
Chennai Analytics Male 15000
;                                                                                                                                     
Run;                                                   
Proc tabulate data = test F=6.0;
Class Location BU Gender;
Var Income;
Table Location=" "*BU=" ", Gender * Income=" "*(N="Count" ROWPCTN="%") / Box="Location BU";
Run;


options nodate pageno=1 linesize=80 pagesize=64;

data carsurvey;
   input Rater Age Progressa Remark Jupiter Dynamo;
   datalines;
1   38  94  98  84  80
2   49  96  84  80  77
3   16  64  78  76  73
4   27  89  73  90  92
77   61  92  88  77  85
78   24  87  88  88  91
79   18  54  50  62  74
80   62  90  91  90  86
;
run;
proc format;
   value agefmt (multilabel notsorted)
         15 - 29 = 'Below 30 years'
         30 - 50 = 'Between 30 and 50'
       51 - high = 'Over 50 years'
         15 - 19 = '15 to 19'
         20 - 25 = '20 to 25'
         25 - 39 = '25 to 39'
         40 - 55 = '40 to 55'
       56 - high = '56 and above';
run;
proc tabulate data=carsurvey format=10.;
 
   class age / mlf;
 
   var progressa remark jupiter dynamo;
 
   table age all, n all='Potential Car Names'*(progressa remark 
      jupiter dynamo)*mean;
   
 
   title1 "Rating Four Potential Car Names";
   title2 "Rating Scale 0-100 (100 is the highest rating)";
 
   format age agefmt.;
run;

data energy;
   length State $2;
   input Region Division state $ Type Expenditures;
   datalines;
1 1 ME 1 708
1 1 ME 2 379
1 1 NH 1 597
1 1 NH 2 301
1 1 VT 1 353
1 1 VT 2 188
1 1 MA 1 3264
1 1 MA 2 2498
1 1 RI 1 531
1 1 RI 2 358
1 1 CT 1 2024
1 1 CT 2 1405
1 2 NY 1 8786
1 2 NY 2 7825
1 2 NJ 1 4115
1 2 NJ 2 3558
1 2 PA 1 6478
1 2 PA 2 3695
4 3 MT 1 322
4 3 MT 2 232
4 3 ID 1 392
4 3 ID 2 298
4 3 WY 1 194
4 3 WY 2 184
4 3 CO 1 1215
4 3 CO 2 1173
4 3 NM 1 545
4 3 NM 2 578
4 3 AZ 1 1694
4 3 AZ 2 1448
4 3 UT 1 621
4 3 UT 2 438
4 3 NV 1 493
4 3 NV 2 378
4 4 WA 1 1680
4 4 WA 2 1122
4 4 OR 1 1014
4 4 OR 2 756
4 4 CA 1 10643
4 4 CA 2 10114
4 4 AK 1 349
4 4 AK 2 329
4 4 HI 1 273
4 4 HI 2 298
;
run;

options nodate pageno=1 linesize=64 pagesize=60;
 
proc tabulate data=energy format=comma12.;
 
   class region division type;
 
   var expenditures;
 
table region*(division all='Subtotal')
         all='Total for All Regions'*f=dollar12.,
 
         type='Customer Base'*expenditures=' '*sum=' '
         all='All Customers'*expenditures=' '*sum=' '
 
      / rts=25;
 
   format region regfmt. division divfmt. type usetype.;
 
   title 'Energy Expenditures for Each Region';
   title2 '(millions of dollars)';
run;

