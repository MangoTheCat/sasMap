
%macro fun2;

    %util1 param3;

    PROC SQL;
       CREATE TABLE BP AS
       SELECT PATIENT, DATE, BPS, BPD
       FROM VITALS;
    QUIT; 
	
%mend fun2;
