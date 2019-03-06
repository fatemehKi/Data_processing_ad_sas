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
  from one, two
  where one.x=two.x;
quit;

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
libname tt "c:\test";
proc sql ;   
   title 'Densities of Countries';
   create table densities as 
      select Name 'Country' format $15.,
             Population format=comma10.0,
             Area as SquareMiles,
             Population/Area format=6.2 as Density
      from country_population;
quit;

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
proc sql outobs=12; 
title 'Largest Country Populations'; 
  select Name, Population format=comma20.,
         max(Population) as MaxPopulation format=comma20. 

  from sql.countries 
  order by Population desc;
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

proc sql;
  select type, sum(invoice) as total_amt
  from sashelp.cars
  group by type
  order by type;
quit;


proc sql;
  select *
  from sashelp.cars
  group by type
  order by type;
quit;

/*The tables PAYROLL2 AND STAFF2 contains data on employees with changes in job code or salary and data on new employees. A report is needed in displaying all information only on new employees as shown below: (ref: 3.8)
IDNUM FNAME LNAME STATE JOBCODE HIRED
To produce this report, break the problem into several steps:
Find the IDNUM values of new employees. “old” employee ID’s stored in the STAFF table. The STAFF2 table contains the ID’s of “old” employees with status changes plus the ID’s of the new employees.
In a separate query, display information about all employees in the STAFF2 and PAYROLL2 tables. For each employee, display the variables IDNUM, FNAME, LNAME, AND STATE from STAFF2 table with the variables JOBCODE AND HIRED from the PAYROLL2 table.
Combine the 2 queries in Part a. and b. so that the results of the second query (displaying all employees) is subset to display only employees returned from the first query.
Create a report displaying employees who have changed job codes (column JOBCODE in the table PAYROLL differs from the same column in the table PAYROLL2). You may use skills acquired in earlier sections. (REF: 3.10)
Output includes the following variables:
IDNUM FNAME LNAME OLD_JOB_CODE NEW_JOB_CODE*/





