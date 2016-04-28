
%macro init;

/* do some initialization */

    %fun2;

    %util1;
	
    PROC SQL;
        CREATE TABLE PATIDS AS
            SELECT DISTINCT PATIENT
                FROM VITALS;
    QUIT;

%mend init;
