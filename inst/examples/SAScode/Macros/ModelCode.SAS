%macro modelcode;

/* some stuff */
    %fun2 param1 param2;

    proc logistic data=Remission outest=betas covout;
       model remiss(event='1')=cell smear infil li blast temp
                    / selection=stepwise
                      slentry=0.3
                      slstay=0.35
                      details
                      lackfit;
       output out=pred p=phat lower=lcl upper=ucl
              predprob=(individual crossvalidate);
    run;
    proc print data=betas;
       title2 'Parameter Estimates and Covariance Matrix';
    run;
    proc print data=pred;
       title2 'Predicted Probabilities and 95% Confidence Limits'; run;	
	
	
%mend modelcode;


  %macro modelcode2;
  
  /* some stuff */
      %fun2 param1 param2;
  
      proc logistic data=Remission outest=betas covout;
         model remiss(event='1')=cell smear infil li blast temp
                      / selection=stepwise
                        slentry=0.3
                        slstay=0.35
                        details
                        lackfit;
         output out=pred p=phat lower=lcl upper=ucl
                predprob=(individual crossvalidate);
      run;
      proc print data=betas;
         title2 'Parameter Estimates and Covariance Matrix';
      run;
      proc print data=pred;
         title2 'Predicted Probabilities and 95% Confidence Limits'; run;	
  	
  	
  %mend;