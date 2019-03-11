/*we can create macro using sql*/
libname library "C:\Users\mfatemeh\Desktop\in share\adv";

data mine;
set library.abc;
run;

data mine_2;
retain a b c sum_a sum_b sum_c;
set mine;
/*if _N_ = 1 then do;
  sum_A=A;
  sum_B=B;
  sum_c=C;
end;
else do;*/
 sum_A = sum_A + A;
 sum_B = sum_B + B;
 sum_C = sum_C + C;
 *end;
 run;

 /*similar to below*/
 data mine_2;
retain a b c sum_a sum_b sum_c;
set mine;
if _N_ = 1 then do;
  sum_A=A;
  sum_B=B;
  sum_c=C;
end;
else do;
 sum_A = sum_A + A;
 sum_B = sum_B + B;
 sum_C = sum_C + C;
 end;
 run;
 proc print data= mine_2;
 run;

 
/*we can add the summation and percentile using proc sql;
 here is how we define the macro in sql using the ":" operators*/
proc sql;
select sum(a), sum(b), sum(c) into :total_A, :TOTAL_B, : TOTAL_C from mine;
quit;
%put total_a = &total_a;
%put total_b = &total_b;
%put total_c = &total_c;

data sas_prec;
set mine_2;
format percent_a percent_b percent_c F5.2;
percent_a = sum_a/&total_a;
percent_b = sum_b/&total_b;
percent_c = sum_c/&total_c;
run;

/* proc export is the other side of proc import*/
proc export data=Work.Sas_prec outfile='C:\Users\mfatemeh\Desktop\abc_Sas_prec.xls' dbms=xls REPLACE;
SHEET='SAS_ABCD1';
run;
 
