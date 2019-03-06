/*SQL in SAS*/
proc sql;
select MSRP-Invoice as difference
from sashelp.cars; /*this semicolumn is the must*/
quit; /*this quit is the must*/

proc sql;
select msrp-invoice as difference
from sashelp.cars
where calculated difference ge 500; /*the word calulated is the must*/
quit;

proc sql;
select enginsize,
case 
when enginsize LE 2 then "LOW"
else "HIGH"
end  "HORSE_POWER"
from sashelp.cars;
quit;

/*the function above is similar to the below*/
data HORSE_POWER;
set sashelp.cars;
length HORSE_POWER $12;
if Enginsize LE 2 then HORSE_POWER ..;
run;

/*coalese with replace by 0 only works for numeric not the character,
for the character we have to use the "" mark and then put what we are planning to use in replacement*/


/*the below is similar to proc content with the only difference that it doesnot show in the output*/
proc sql;
describe table example1;
quit;

proc sql outobs=50;
select type, origin, model, Enginesize
from sashelp.cars
where origin in ("Europe") and enginesize LE 2;
quit;

/*format=comma20. means the maximum lenngth is 20*/

/*counting unique vars in sas*/
proc sql;
select count(TYPE) as count_type
from sashelp.cars;
quit;

proc sql;
select count(distinct type) as dis_type
from sashelp.cars;
quit;

proc sql;
select distinct type
from sashelp.cars;
quit;

proc freq data= sashelp.cars;
table type;
run;

data one;
input x y;
cards;
1 5
2 6
;
run;
data two;
input x z;
cards;
2 4
;
run;

proc sql;
create table three as
select * 
from one join two
on one.x=two.x;
quit;

proc print data=three;
run;

proc sql;
create table four as
select * 
from one left join two
on one.x=two.x;
quit;

proc print data=four;
run;

proc sql;
create table five as
select * 
from one right join two
on one.x=two.x;
quit;

/*if we do not have the "create table" after the proc sql it wikk print out automatically
and it creares a temporary table for it but is we use the create table we will not see the
pop up automatically and by defining a permanent library we will be able to make a permanetn data set.
but most of the time we need to create a table because we need to pop it up after however we eed extra code 
for peintig the data*/
