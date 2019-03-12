libname tt "\\file1\LabShare\DSA 04-Feb-2019\SAS\data";
/*
data tt.wireless;
  length Acctno $13 DeactReason $4 DealerType $2 Province $2; 
  infile "\\file1\LabShare\DSA 04-Feb-2019\SAS\data\New_Wireless_Fixed.txt" DSD; 
  informat  Actdt mmddyy10. Deactdt mmddyy10. sales dollar8.2; 
  input @1  Acctno $13.
        @15 Actdt  mmddyy10.
        @26 Deactdt mmddyy10.
        @41 DeactReason $4. 
        @53 GoodCredit 1.
        @62 RatePlan 1. 
        @65 DealerType $2.
        @74 AGE 2.
        @80 Province $2.
        @85 Sales    dollar8.2 
;
run;
*/
proc sort data=tt.wireless out=wireless nodupkey;
  by acctno;
run;

proc freq data=wireless;
  table province/missing list;
run;
data test;
  set wireless;
  where province not like '$%';
run;
/* S1 */
data active deactive;
  length region $20;
  set tt.wireless(where=( province not like '$%'));
       if province in ( 'BC','SK','AB')      then region='West Provinces';
  else if province in ( 'PE','NS','NB','NL') then region='Ocean Provinces';
  else if province in ('MT','QC','ON' )      then region='Central Provinces';
  else                                            region='Unknown';
  Acctnum=input(Acctno, 13.);
  if Actdt ^=. and Deactdt=. then output active;
  else                            output deactive;
run;
data tt.wireless1;
  set active deactive;
  if Deactdt=. then
    do;
	   active=1;
       tenure=intck('day', Actdt,date());
	end;
  else if Deactdt ^=. then
    do;
	   active=0;
	   tenure=intck('day',Actdt, Deactdt);
	end;
  else   
    do;
	   active=.;
	   tenure=.;
	end; 
run;
proc freq data=active;
  table region*province/missing list;
run;

proc freq data=deactive;
  table region*province/missing list;
run;

%macro tst(data, var);
  proc means data=&data min max ;
    var &var;
	output out=&var._status;
  run;
  proc print data=&var._status;
    var _stat_ &var;
	format &var date9.;
  run;
%mend;
%tst(active, Actdt);
%tst(deactive, Deactdt);

/*S2*/
%macro dis(data, var);
  proc freq data=&data;
    table &var/missing list;
	title "Data &data Distribution by &var";
  run;
    title ' ';
%mend;
%dis(active, age);
%dis(active, province);

%dis(Deactive, age);
%dis(Deactive, province);
/*
Sales segment: < $100, $100---500, $500-$800, $800 and above.
Age segments: < 20, 21-40, 41-60, 60 and above. */

/*S3*/

proc format;
  value fmtage
     Low -<21 ='<= 20  '
	 21 -<41  ='21 - 40'
	 41 -<61  ='41 - 60'
	 61 - high='61+    '
	 ;
  value fmtsale
     Low -<101='<=100  '
	 101 -<501='101-500'
	 501 -<801='501-800'
	 801 -high='801 +  '
	 ;
  value $fmtprov
        'BC','SK','AB'     ='West Provinces   '
		'PE','NS','NB','NL'='Ocean Provinces  '
		'MT','QC','ON'     ='Central Provinces'
		other              ='Unknown          '
		;
run;

proc freq data=wireless;
  table province/missing list;
  format province $fmtprov.;
run;

proc tabulate data=Active missing noseps;
  class region province age sales;
  var Acctnum;
  format age fmtage. sales fmtsale.;
  table  region=' '*province=' ' all,
        age=' '*sales='Number of Accounts'*Acctnum=' '*N=' ' ;
run;

ods listing close;
ods html file="Active.xls";
proc tabulate data=Active missing noseps;
  class region province age sales;
  var Acctnum;
  format age fmtage. sales fmtsale.;
  table  region=' '*province=' ' all,
        age=' '*sales='Number of Accounts'*Acctnum=' '*N=' ' ;
run;
ods _all_ close;
ods listing;

%macro listt(data);
ods listing close;
ods html file="&data..xls";
proc tabulate data=&data missing noseps;
  class region province age sales;
  var Acctnum;
  format age fmtage. sales fmtsale.;
  table  region=' '*province=' ' all,
        age=' '*sales='Number of Accounts'*Acctnum=' '*N=' ' ;
run;
ods _all_ close;
ods listing;
%mend;
%listt(Active);

/*S4*/
/*4.1*/

data S4_1;
  set active deactive;;
  if Deactdt=. then
    do;
	   active=1;
       tenure=intck('day', Actdt,date());
	end;
  else if Deactdt ^=. then
    do;
	   active=0;
	   tenure=intck('day',Actdt, Deactdt);
	end;
  else   
    do;
	   active=.;
	   tenure=.;
	end; 
run;
proc means data=tt.wireless n nmiss;
  var Actdt;
run;

proc means data=S4_1 n nmiss min mean max;
  class active;
  var tenure;
run;

/*4.2*/

data S4_2;
  set S4_1(where=(active=0));
  deactive_mth=month(Deactdt);
run;

proc freq data=s4_2;
  table deactive_mth/missing list;
run;

/*4.3*/

proc format;
  value fmttenure
    low-<31 ='<=30 days    '
	31-<61  ='31-60 days   '
	61-<366 ='61-365 days  '
	366-high='Over one year'
	;
run;


proc tabulate data=S4_1 missing noseps;
  class active tenure;
  var Acctnum;
  format tenure fmttenure.;
  table  active=' ' all,
        tenure=' '*Acctnum=' '*N=' '  all;
run;

proc freq data=S4_1 ;
  table tenure/missing lsit;
run;

/*4.4*/


proc tabulate data=S4_1(where=(active=0)) missing noseps;
  class tenure;
  var goodcredit rateplan;
  format tenure fmttenure.;
  table  tenure=' ' all,
         goodcredit*(N MEAN) rateplan*(N MEAN);
run;


proc freq data=S4_1(where=(active=0));
  table dealertype/missing list;;
run;

/*4.5*/


proc freq data=s4_1;
  table active*tenure;
  format tenure fmttenure.;
run;

/*4.6*/

proc tabulate data=S4_1 missing noseps;
  class active age;
  var goodcredit rateplan;
  format age fmtage.;
  table  active, 
         age=' ' all,
         goodcredit*MEAN rateplan*MEAN;
run;;


proc tabulate data=S4_1 missing noseps;
  class active age;
  var goodcredit rateplan;
  format age fmtage.;
  table  active*age=' ' all,
         goodcredit*MEAN rateplan*MEAN;
run;;

/******* Exercise *********/





