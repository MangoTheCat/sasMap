/* Just samples for demoing of sasMap's feature */
/* The code here may even not runnable under SAS */


%init;

data MyLib.iris;             
    set Sashelp.iris;        
RUN;                
        
data MyLib.iris;             
    set  MyLib.iris;         
    PetalLength = 0;         
RUN; 

%modelcode;