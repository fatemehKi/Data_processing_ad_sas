LIBNAME TT "\\file1\LabShare\DSA 04-Feb-2019\SAS\data";
DATA ABC;
  RETAIN A B C SUM_A SUM_B SUM_C;
  SET tt.ABC;
    
	if _n_ = 1 then do;
	    sum_A = A;
		sum_B = B;
		sum_C = C;
	end;
	else do;
	    sum_A = sum_A + A;
		sum_B = sum_B + B;
		sum_C = sum_C + C;	
	end;
run;
PROC PRINT DATA=ABC;
RUN;
PROC SQL NOPRINT;
  
  SELECT SUM(A),
         SUM(B) ,
         SUM(C)
  INTO : TOTAL_A, : TOTAL_B, : TOTAL_C
  FROM ABC;
QUIT;
%PUT TOTAL_A=&TOTAL_A;
%PUT TOTAL_B=&TOTAL_B;
%PUT TOTAL_C=&TOTAL_C;


DATA SAS_ABCD;
  SET ABC;
  PERC_A=SUM_A/&TOTAL_A;
  PERC_B=SUM_B/&TOTAL_B;
  PERC_C=SUM_C/&TOTAL_C;
  FORMAT PERC_A PERC_B PERC_C F5.2;
RUN;

PROC EXPORT DATA= WORK.SAS_ABCD 
            OUTFILE= "C:\test\SAS_ABCD.xls" 
            DBMS=EXCEL REPLACE;
     SHEET="SAS_ABCD1"; 
RUN;
