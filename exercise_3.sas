*Class EXERCISE: two table of staf and promoted staf and we are looking for
those wich are new not promoted and those that are new;
libname exer "C:\Users\mfatemeh\Desktop\data";
proc sql;
describe table exer.STAFF;
quit;

proc print data = exer.STAFF;
run;

proc sql;
create table old_emp as
select *
from exer.STAFF;
quit;

proc sql;
create table new_prom_emp as
select *
from exer.STAFF2;
quit;

proc sql;
create table old_emp_payr as
select *
from exer.PAYROLL;
quit;

proc sql;
create table new_prom_emp_payr as
select *
from exer.PAYROLL2;
quit;

proc sql;
create table new_emp_prom_info as 
select * 
from new_prom_emp join new_prom_emp_payr
on new_prom_emp.IDNUM= new_prom_emp_payr.IDNUM;
quit;

proc sql;
create table result_one as
select * 
from new_emp_prom_info left join old_emp
on new_emp_prom_info.IDNUM= old_emp.IDNUM
where old_emp.IDNUM is null;
quit;

proc sql;
select IDNUM, FNAME, LNAME, STATE, JOBCODE, HIRED
from result_one;
quit;

proc sql;
create table result_two as
select *
from new_emp_prom_info inner join old_emp
on new_emp_prom_info.IDNUM= old_emp.IDNUM;
quit;

proc sql;
select IDNUM, FNAME, LNAME, STATE, JOBCODE, HIRED
from result_two;
quit;







