

%macro util2;

    %util1;

    %summary;

	proc contents data= test  position; 
        run;

    PROC SQL;
        SELECT * FROM VITALS;
    QUIT;
		
%mend util2;

