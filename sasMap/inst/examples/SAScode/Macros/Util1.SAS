
%macro util1;

    %fun1;

    proc freq data=Color order=data;
       tables Eyes*Hair / expected cellchi2 norow nocol chisq;
       output out=ChiSqData n nmiss pchi lrchi;
       weight Count;
       title 'Chi-Square Tests for 3 by 5 Table of Eye and Hair Color';
    run;
	
    proc print data=ChiSqData noobs;
       title1 'Chi-Square Statistics for Eye and Hair Color';
       title2 'Output Data Set from the FREQ Procedure';
    run;

%mend util1;


