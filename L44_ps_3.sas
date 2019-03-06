data one;
  input x y;
  cards;
  1 5
  2 10
  3 20
  4 40
  5 80
  ;
run;

data two;
  input x z;
  cards;
  2 100
  6 200
  8 300
  9 500
  ;
run;

/* Inner Joins  */
proc sql;
  create table three as
  select *
  from one a, two b
  where a.x=b.x;
quit;
proc print data=three; run;

/* Left Outer Joins   */
proc sql;
  create table three as
  select *
  from one left join two
  on one.x=two.x;
quit;

/* Right Outer Joins   */
proc sql;
  create table three as
  select *
  from one right join two
  on one.x=two.x;
quit;
/* Full Outer Joins  */
proc sql;
  create table three as
  select *
  from one, two;
quit;

proc print data=three;
run;

data country_population;
  input name $ Population area ;
  cards;

Afghanistan 17070323 251825    
Albania 3407400 11100   
Algeria 28171132 919595    
Andorra 64634 200   
Angola 9901050 481300    
Antigua 65644 171   
Argentina 34248705 1073518    
Armenia 3556864 11500   
Australia 18255944 2966200     
Austria 8033746 32400  
;
run;

proc sql ;   
   title 'Densities of Countries';
   create table densities as
      select Name 'Country' format $15.,
             Population format=comma10.0,
             Area as SquareMiles,
             Population/Area format=6.2 as Density
         from country_population;
proc sql;
   select * from densities;
quit;

proc sql ;   
   title 'Densities of Countries';
   create view densities as
      select Name 'Country' format $15.,
             Population format=comma10.0,
             Area as SquareMiles,
             Population/Area format=6.2 as Density
         from country_population;
proc sql;
   select * from densities;
quit;

data us_city;
  input city $ state $ latitude longitude;
  cards;

Albany      NY 43 -74
Albuquerque NM 36 -106
Amarillo    TX 35 -102
Anchorage   AK 61 -150
Annapolis   MD 39 -77
Atlanta     GA 34 84
Augusta     ME 44 -70
Austin      TX 30 -98
Baker       OR 45 -118
Baltimore   MD 39 -76
Bangor      ME 45 -69
Baton       LA 31 -91
;
run;

data population;
  input name $ population;
  cards;
     China         1202215077         
     India         929009120         
     USA           263294808         
     Indonesia     202393859         
     Brazil        160310357         
     Russia        151089979         
     Bangladesh    126387850         
     Japan         126345434         
     Pakistan      123062252         
     Nigeria       99062003         
     Mexico        93114708         
     Germany       81890690         
;
run;
proc sql;
title 'Largest Country Populations'; 
   select Name, Population format=comma20.,
          max(Population) as MaxPopulation format=comma20. 
   from population  
   order by Population desc;
quit;

proc sql;
  select *
  from sashelp.cars;
quit;

proc sql;
  create table cards as
  select model, type, origin, invoice, msrp
  from sashelp.cars;
quit;

proc sql;
  select distinct type
  from sashelp.cars;
quit;

proc sort data=sashelp.cars(keep=type) out=car nodupkey;
  by type;
run;
proc print data=car; run;

proc sql;
  select (msrp-invoice) as difference
  from sashelp.cars;
quit;

data test(keep=difference);
  set sashelp.cars(keep=msrp invoice);
  difference=msrp - invoice;
run;
proc print data=test noobs;
run;

proc sql outobs=10;
  select type, origin, "type & origin" as description
  from sashelp.cars;
quit;

proc sql;
  select msrp - invoice as difference, 1000 as bonus
  from sashelp.cars;
quit;

data test1;
  set sashelp.cars;
  difference=msrp - invoice;
  description="type & origin";
  bonus=1000;
run;
proc print data=test1;
  var difference description bonus;
run;

proc sql;
  select (msrp-invoice) as difference
  from sashelp.cars
  where calculated difference>=5000;
quit;

proc sql;
  select enginesize,
    case
	when   enginesize<=2   then "LOW"
	when 2<enginesize<=3   then "INTERMEDIATE"
	else                        "HIGH"
	end "HORSE_POWER"
  from sashelp.cars
  ;
quit;

data HORSE_POWER;
  LENGTH HORSE_POWER $12;
  SET SASHELP.CARS;
       IF   ENGINESIZE<=2 THEN HORSE_POWER="LOW";
  ELSE IF 2<ENGINESIZE<=3 THEN HORSE_POWER="INTERMEDIATE";
  ELSE                         HORSE_POWER="HIGH";
RUN;

PROC PRINT DATA=HORSE_POWER;
  VAR ENGINESIZE HORSE_POWER;
RUN;

DATA example;
  input id $ gender $ price @@;
  tax=round(price*0.13, 0.1);
datalines;
001 M 218.30 002 F 663.5
003 F .      004 M 107.40
005 F 586.50 006 M .
007 M 463.20 008 F 185.00
009 M 682.30 010 M 3362.00
;
run;
proc print data=example; run;

proc sql;
  select id, coalesce (price,1) as n_price, coalesce (tax, 1) as n_tax
  from example;
quit;

/* coalesce returns the first nonmissing value from a list ofnumeric arguments. */

data example1;
  set example;
  if gender ^='M' then gender='   ';
  else                 gender=gender;
run;
proc print data=example1; run;

proc sql;
  select id, gender, coalesce(gender, "F") as n_gender
  from example1;
quit;

proc sql;
  select id, (price*0.13) as tax format=dollar8.2 label="TAX_AMOUNT",
             price+(price*0.13) as total_amt format=dollar8.2 label="TOTAL_AMOUNT"
  from example;
quit;

proc sql;
  describe table example1;
quit;


proc sql;
  select distinct type, origin, "test" as descrip
  from sashelp.cars;
quit;

proc sql outobs=5;
  select msrp -invoice as difference 
  from sashelp.cars
  where calculated difference ge 5000
  ;
quit;

proc sql;
  select *
  from example
  where price is missing 
  ;
quit;

proc sql;
  select *
  from example
  where price is null 
  ;
quit;


proc sql;
  select *
  from sashelp.cars
  where origin="Europe" 
  ;
quit;

proc sql;
  select *
  from sashelp.cars
  where origin="Europe" and
        enginesize<2;
quit;

proc sql;
  select *
  from sashelp.cars
  where origin not in ("Europe", "Asia")
  ;
quit;


/*The tables PAYROLL2 AND STAFF2 contains data on employees with changes in job code or salary and data on new employees. A report is needed in displaying all information only on new employees as shown below: (ref: 3.8)
IDNUM FNAME LNAME STATE JOBCODE HIRED
To produce this report, break the problem into several steps:
Find the IDNUM values of new employees. “old” employee ID’s stored in the STAFF table. The STAFF2 table contains the ID’s of “old” employees with status changes plus the ID’s of the new employees.
In a separate query, display information about all employees in the STAFF2 and PAYROLL2 tables. For each employee, display the variables IDNUM, FNAME, LNAME, AND STATE from STAFF2 table with the variables JOBCODE AND HIRED from the PAYROLL2 table.
Combine the 2 queries in Part a. and b. so that the results of the second query (displaying all employees) is subset to display only employees returned from the first query.
Create a report displaying employees who have changed job codes (column JOBCODE in the table PAYROLL differs from the same column in the table PAYROLL2). You may use skills acquired in earlier sections. (REF: 3.10)
Output includes the following variables:
IDNUM FNAME LNAME OLD_JOB_CODE NEW_JOB_CODE */

libname sl "E:\SAS_F\SAS Advanced_Final\SQL";
/* New */
proc sql;
  select idnum
  from sl.staff2
  except all
  select idnum
  from sl.staff;
quit;

/* New */
proc sql;
  select idnum
  from sl.staff2
  where idnum not in
  (select idnum
  from sl.staff);
quit;

/* existing and change job title */
proc sql;
  select distinct a.idnum
  from sl.staff2 a, sl.staff b
  where a.idnum =b.idnum;
quit;

/* new and changed job old emp */
proc sql;
  select a.idnum, b.fname, b.lname, b.state, a.jobcode, a.hired
  from sl.payroll2 a, sl.staff2 b
  where a.idnum=b.idnum;
quit;

/* New only */
proc sql;
  select a.idnum, fname, lname, state, jobcode, hired
  from sl.payroll2 a, sl.staff2 b
  where a.idnum=b.idnum and
        a.idnum in 
		(select idnum
		 from sl.staff2
		 except all
		 select idnum
		 from sl.staff);
quit;

proc sql;
  select  a.idnum, fname, lname, state, jobcode, hired
  from sl.staff2 a, sl.payroll2 b
  where a.idnum=b.idnum and
        a.idnum not in
		(select idnum
		 from sl.staff);
quit;

proc sql;
  select a.idnum, fname, lname, state, jobcode, salary
  from sl.payroll2 a, sl.staff2 b
  where a.idnum=b.idnum 
  union 
  select c.idnum, fname, lname, state, jobcode, salary
  from sl.payroll c, sl.staff d
  where c.idnum=d.idnum and
        c.idnum not in
		(select idnum
		 from sl.payroll2)
  order by 1;
quit;

proc sql;
  select a.idnum, b.fname, b.lname,
         a.jobcode label="old job code",
		 c.jobcode label="new job code"
  from sl.payroll a, sl.staff b, sl.payroll2 c
  where a.idnum=b.idnum and
        a.idnum=c.idnum and
		a.jobcode ^= c.jobcode;
quit;









