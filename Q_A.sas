/* Version I */
data test;
  input item $ t1 $  t2 $ ;
  cards;
  a 1 2
  a 3 4
  b 5 6
  b 7 8
  b 9 10
  ;
run;

OPTIONS MPRINT SYMBOLGEN MLOGIC;

%macro sepdata(a,b,c,a1,b1);

proc sql;
  select count(item) into : num_&a
  from test
  where item="&a";

  select count(item) into : num_&b
  from test
  where item="&b";
quit;
%put &&num_&a &&num_&b;

data &a(drop= item );
  set test(where=(item="&a"));
run;

data &b(drop= item );
  set test(where=(item="&b"));
run;

data aa(drop= t1 t2 i j );
  set &a nobs=nobs;
  array all(&&num_&a, &c) $ x1 - x&a1;
  array vars(*) $ t1 t2;
  retain x1-x&a1;   
   i+1;   
     do j=1 to 2;     
        all( i,j )=vars( j );   
     end;  
   put x1-x&a1;  /* for information only */   
   if _n_= nobs then output;  
run; 

proc print data=aa;
run;

data bb(drop= t1 t2 i j );
  set &b nobs=nobs;
  array all(&&num_&b, &c) $ x1 - x&b1;
  array vars(*) $ t1 t2;
  retain x1-x&b1;   
   i+1;   
     do j=1 to 2;     
        all( i,j )=vars( j );   
     end;  
   put x1-x&b1;  /* for information only */   
   if _n_= nobs then output;  
run; 

proc print data=bb;
run;

data ab;
  set aa(in=a) bb(in=b);
       if a then item='a';
  else if b then item='b';
run;

proc print data=ab;
  var item x1 - x&b1;
run;

%mend sepdata;
%sepdata(a,b,2,4,6);;

/* Version II */

data test;
  input item $ t1   t2 ;
  cards;
  a 1 2
  a 3 4
  b 5 6
  b 7 8
  b 9 10
  ;
run;

OPTIONS MPRINT SYMBOLGEN MLOGIC;

%macro sepdata(a,b,c,a1,b1);

proc sql;
  select count(item) into : num_&a
  from test
  where item="&a";

  select count(item) into : num_&b
  from test
  where item="&b";
quit;
%put &&num_&a &&num_&b;

data &a(drop= item );
  set test(where=(item="&a"));
run;

data &b(drop= item );
  set test(where=(item="&b"));
run;

data aa(drop= t1 t2 i j );
  set &a nobs=nobs;
  array all(&&num_&a, &c)  x1 - x&a1;
  array vars(*)  t1 t2;
  retain x1-x&a1;   
   i+1;   
     do j=1 to 2;     
        all( i,j )=vars( j );   
     end;  
   put x1-x&a1;  /* for information only */   
   if _n_= nobs then output;  
run; 

proc print data=aa;
run;

data bb(drop= t1 t2 i j );
  set &b nobs=nobs;
  array all(&&num_&b, &c)  x1 - x&b1;
  array vars(*)  t1 t2;
  retain x1-x&b1;   
   i+1;   
     do j=1 to 2;     
        all( i,j )=vars( j );   
     end;  
   put x1-x&b1;  /* for information only */   
   if _n_= nobs then output;  
run; 

proc print data=bb;
run;

data ab;
  set aa(in=a) bb(in=b);
       if a then item='a';
  else if b then item='b';
run;

proc print data=ab;
  var item x1 - x&b1;
run;

%mend sepdata;
%sepdata(a,b,2,4,6);

