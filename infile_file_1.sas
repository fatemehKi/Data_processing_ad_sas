/*points:
1. the numeric that is char shows missing not error
2. the undefined length character takes the first defined variable length
*/

/*advanced sas*/
/*
ins:
infile 'datalines' to get the data    file 'c:\sas\data\file.sas' /---location that we are directing to---/
input var1.. varn                     put var1
import                                export

/*
The DSD (Delimiter-Sensitive Data) in infile statement does three things for you.
1: it ignores delimiters in data values enclosed in quotation marks; 
2: it ignores quotation marks as part of your data; 
3: it treats two consecutive delimiters in a row as missing value.
--more flexible input*/

/*_NULL_ does not create any data*/
data c;
infile datalines;
input name : $20;
datalines;
fatem
;
run;

 

data _NULL_;
file 'c:/mine/test.csv';
 set c;
 put data: ddmmy10.;
run;


/*----- practice----*/
data mine;
infile datalines;
input @1 fname : $10. @11 lname : $10. @20 date ddmmyy10.;
datalines;
fateme    kiaie     4.3.2019
;
run;

data _NULL_;
file 'C:\Users\mfatemeh\Desktop\test\test.csv';
set mine;
put @1 fname : $10. @11 lname : $10. @20 date ddmmyy10.;
run;
/*didn't work 
data _NULL_;
file 'C:\Users\mfatemeh\Desktop\test\tes.xlsx';
set mine;
put fname $20. lname $10. date ddmmyy10.;
run;*/

data mine_2;
infile 'C:\Users\mfatemeh\Desktop\test\tes.csv';
input @1 fname : $10. @11 lname : $10. @20 date ddmmyy10.;
run;



